//
//  SubscriptionViewModel.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/29.
//

import Foundation
import StoreKit

class SubscriptionViewModel:ObservableObject {
    
    @Published var subscriptions:[SubscriptionPlan] = []
    @Published var purchasedSubscriptions: [SubscriptionPlan] = []
    @Published var subscriptionGroupStatus: RenewalState?
    @Published var errorMessage:String?
    @Published var isLoading = false
    @Published var isPurchaseComplete = false
    private var updateListenerTask: Task<Void, Error>? = nil
    let subscriptionList = ["herbal.delivery.1month","herbal.delivery.2month","herbal.delivery.3month"]
    
    let storeService = StoreService()
    
    init(){
        updateListenerTask = listenForTransactions()
        Task{
            await requestSubscription()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    @MainActor
    func requestSubscription() async {
        do{
            isLoading = true
            self.subscriptions =  try await storeService.requestProduct(subscriptionList: subscriptionList)
            isLoading = false
        }catch{
            isLoading = false
            errorMessage = storeService.getErrorMessage(error: error)
        }
    }
    
    @MainActor
    func purchaseSubscription(_ product:Product) async {
        do{
            isLoading = true
            try await storeService.purchase(product)
            await updateCustomerProductStatus()
            isLoading = false
            isPurchaseComplete = true
        }catch{
            isLoading = false
            errorMessage = storeService.getErrorMessage(error: error)
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
    
            for await result in Transaction.updates {
                do {
                    let transaction = try self.storeService.checkVerified(result)
                    
                    await self.updateCustomerProductStatus()

                    await transaction.finish()
                    print("listenForTransactions○")
                } catch {
                    print("listenForTransactions×")
                }
            }
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        
        var purchasedSubscriptions: [SubscriptionPlan] = []
        
        for await result in Transaction.currentEntitlements {
            
            do{
                let transaction = try self.storeService.checkVerified(result)
    
                if let subscription = subscriptions.map({$0.product}).first(where: { $0.id == transaction.productID }) {
                    
                    purchasedSubscriptions.append(SubscriptionPlan(id: subscription.id, product: subscription))
                }
                print("updateCustomerProductStatus○")
            }catch{
                print("updateCustomerProductStatus×")
            }
        }
        self.purchasedSubscriptions = purchasedSubscriptions
        self.subscriptionGroupStatus = try? await subscriptions.map({$0.product}).first?.subscription?.status.first?.state
    }
    
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
}
