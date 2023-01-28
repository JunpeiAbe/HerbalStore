//
//  StoreService.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/29.
//

import StoreKit
import FirebaseFirestore

typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState
typealias Transaction = StoreKit.Transaction

struct SubscriptionPlan:Identifiable,Equatable {
    let id:String
    let product:Product
    var isChecked = false
}

public enum SubscriptionTier: Int, Comparable {
    case none = 0
    case oneMonth = 1
    case twoMonths = 2
    case threeMonths = 3
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

struct StoreService {
    
    //■購入データ保存
    func savePurchasedItem(cartItem:CartItem) {
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        let data = ["image":cartItem.image,"name":cartItem.name,"price":cartItem.price,"quantity":cartItem.quantity,"date":Timestamp(date:Date()),"userID":uid] as [String : Any]
        
        COLLECTION_PURCHASED.document(uid).collection("purchasedItem").document().setData(data){_ in
        }
    }
    
    //購入データフェッチ
    func fetchPurchasedItem(isLoading:@escaping(() -> Void),completion:@escaping(([PurchasedItem]) -> Void
    )) {
        var purchasedItems = [PurchasedItem]()
        
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        
        COLLECTION_PURCHASED.document(uid).collection("purchasedItem").order(by: "date").getDocuments{ snapshot, _ in
            
            guard let documents = snapshot?.documents else {
                isLoading()
                return
            }
            
            purchasedItems = documents.compactMap({try? $0.data(as: PurchasedItem.self)})
            completion(purchasedItems)
        }
    }
    
    func requestProduct(productID:String) async throws-> [Product] {
        
        let products = try await Product.products(for: [productID])
        
        return products
    }
    
    func purchase(cartItem:CartItem, herbals:[Product]) async throws{
        
        let quantity = Int(truncating: cartItem.quantity)
        let options: Set<Product.PurchaseOption> = [.quantity(quantity)]
        guard let product = herbals.first else {return}
        
        let result = try await product.purchase(options: options)
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            self.savePurchasedItem(cartItem: cartItem)
            await transaction.finish()
        case .userCancelled:
            throw StoreError.userCancelled
        case .pending:
            throw StoreError.pending
        @unknown default:
            throw StoreError.unknown
        }
    }
    
    
    func requestProduct(subscriptionList:[String]) async throws -> [SubscriptionPlan]{
        
        var subscriptions = [SubscriptionPlan]()
        
        let products = try await Product.products(for: subscriptionList)
        
        for product in products {
            subscriptions.append(SubscriptionPlan(id: product.id, product: product))
        }
        return subscriptions
        
    }
    
    func purchase(_ product:Product) async throws {
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            //await updateCustomerProductStatus()
            await transaction.finish()
        case .userCancelled:
            throw StoreError.userCancelled
        case .pending:
            throw StoreError.pending
        @unknown default:
            throw StoreError.unknown
        }
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
