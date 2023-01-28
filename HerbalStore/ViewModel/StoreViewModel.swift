//
//  StoreManager.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/10.
//

import Foundation
import StoreKit
import SwiftUI
import FirebaseFirestore

struct SubscriptionPlan:Identifiable,Equatable {
    let id:String
    let product:Product
    var isChecked:Bool = false
}

//■消費型商品とサブスクリプション型商品の購入処理を実装する
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState
typealias Transaction = StoreKit.Transaction

public enum SubscriptionTier: Int, Comparable {
    case none = 0
    case oneMonth = 1
    case twoMonths = 2
    case threeMonths = 3
    
    //比較の基準
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

class StoreViewModel:ObservableObject{
    
    func tier(for productId: String) -> SubscriptionTier {
        switch productId {
        case "herbal.delivery.1month":
            return .oneMonth
        case "herbal.delivery.2month":
            return .twoMonths
        case "herbal.delivery.3month":
            return .threeMonths
        default:
            return .none            
        }
    }
    
    let subscriptionList = ["herbal.delivery.1month","herbal.delivery.2month","herbal.delivery.3month"]
    
    @Published var herbals:[Product] = []
    @Published var purchasedItems:[PurchasedItem] = []
    @Published var subscriptions:[SubscriptionPlan] = []
    @Published var purchasedSubscriptions: [SubscriptionPlan] = []
    @Published var subscriptionGroupStatus: RenewalState?
    @Published var errorMessage:String?
    @Published var isLoading = false
    @Published var isPurchaseComplete = false
    var updateListenerTask: Task<Void, Error>? = nil
    
    static let shared = StoreViewModel()
        
    init(){
        updateListenerTask = listenForTransactions()
        //fetchPurchasedItem()
        errorMessage = nil
        Task {
            await requestProduct()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    //■購入品データの保存
    func savePurchasedItem(cartItem:CartItem) {
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        let data = ["image":cartItem.image,"name":cartItem.name,"price":cartItem.price,"quantity":cartItem.quantity,"date":Timestamp(date:Date()),"userID":uid] as [String : Any]
        
        COLLECTION_PURCHASED.document(uid).collection("purchasedItem").document().setData(data){_ in
            print("購入品データ保存")
        }
    }
    //■購入品データのフェッチ(SettingView)
    func fetchPurchasedItem() {
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        isLoading = true
        COLLECTION_PURCHASED.document(uid).collection("purchasedItem").order(by: "date").getDocuments{ snapshot, error in
            
            if error != nil{
                self.isLoading = false
                return
            }
            
            guard let documents = snapshot?.documents else {
                self.isLoading = false
                return
            }
            
            self.purchasedItems = documents.compactMap({try? $0.data(as: PurchasedItem.self)})
            self.isLoading = false
            print("購入履歴受信◯")
        }
    }
    
    //■CartViewのリクエスト◯
    @MainActor
    func requestProduct(productID:String) async {
        
        do {
            //isLoading = true
            let products = try await Product.products(for: [productID])
            self.herbals = products
        } catch {
            print("エラーの内容(リクエスト):",error)
            errorMessage = getErrorMessage(error: error)
            //isLoading = false
        }
    }
    
    //■CartViewの購入◯
    @MainActor
    func purchase(cartItem:CartItem) async throws{
        
        errorMessage = nil
        
        let quantity = Int(truncating: cartItem.quantity)
        let options: Set<Product.PurchaseOption> = [.quantity(quantity)]
        guard let product = herbals.first else {return}
        
        do{
            let result = try await product.purchase(options: options)
            isLoading = true
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                savePurchasedItem(cartItem: cartItem)
                await transaction.finish()
                isLoading = false
                isPurchaseComplete = true
                
            case .userCancelled:
                throw StoreError.userCancelled
            case .pending:
                throw StoreError.pending
            @unknown default:
                throw StoreError.unknown
            }
            
        
        }catch{
            print("エラーの内容(購入):",error)
            isLoading = false
            errorMessage = getErrorMessage(error: error)
        }
    }
    
    //■サブスクリプションのリクエスト
    @MainActor
    func requestProduct() async {
            
        do {
            isLoading = true
            let products = try await Product.products(for: subscriptionList)
            
            for product in products {
                self.subscriptions.append(SubscriptionPlan(id: product.id, product: product))
            }
            isLoading = false
        }catch{
            isLoading = false
            print("エラーの内容(リクエスト):",error)
            errorMessage = getErrorMessage(error: error)
            
        }
    }
    
    //■サブスクリプションの購入
    @MainActor
    func purchase(_ product:Product) async throws {
        
        do{
            let result = try await product.purchase()
            isLoading = true
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updateCustomerProductStatus()
                await transaction.finish()
                isLoading = false
                isPurchaseComplete = true
            case .userCancelled:
                throw StoreError.userCancelled
            case .pending:
                throw StoreError.pending
            @unknown default:
                throw StoreError.unknown
            }
        }catch{
            print("エラーの内容(購入):",error)
            isLoading = false
            errorMessage = getErrorMessage(error: error)
        }
        
    }
    
    //■トランザクションの更新を監視する(サブスクリプションの期限切れ以外)
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
    
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    //購入情報の更新を行う↓
                    await self.updateCustomerProductStatus()

                    await transaction.finish()
                    print("listen for Transaction, update listenerTask")
                } catch {
                    self.isLoading = false
                    print("Transaction failed verification")
                }
            }
        }
    }
    //■トランザクションの更新を監視する
    @MainActor
    func updateCustomerProductStatus() async {
        
        var purchasedSubscriptions: [SubscriptionPlan] = []
        
        for await result in Transaction.currentEntitlements {
            
            do{
                let transaction = try self.checkVerified(result)
    
                if let subscription = subscriptions.map({$0.product}).first(where: { $0.id == transaction.productID }) {
                    
                    purchasedSubscriptions.append(SubscriptionPlan(id: subscription.id, product: subscription))
                }
                print("update customerProductStatus success")
            }catch{
                self.isLoading = false
                print("Transaction failed verification")
            }
        }
        self.purchasedSubscriptions = purchasedSubscriptions
        subscriptionGroupStatus = try? await subscriptions.map({$0.product}).first?.subscription?.status.first?.state
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    func getErrorMessage(error: Error) -> String {
        switch error {
        case StoreError.userCancelled:
            return "購入がキャンセルされました"
        case StoreError.pending:
            return "購入が保留されています"
        case StoreError.productUnavailable:
            return "指定した商品が無効です"
        case StoreError.purchaseNotAllowed:
            return "OSの支払い機能が無効化されています"
        case StoreError.failedVerification:
            return "トランザクションデータの署名が不正です"
        case StoreError.unknown:
            return "エラーが発生しました。電波状況の良いところで再度お試しください。"
        default:
            return "エラーが発生しました。電波状況の良いところで再度お試しください。"
        }
    }
    
}
