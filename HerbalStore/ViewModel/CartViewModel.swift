//
//  CartItemViewModel.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/29.
//

import StoreKit

class CartViewModel:ObservableObject {
    
    @Published var herbals:[Product] = []
    @Published var errorMessage:String?
    @Published var isLoading = false
    @Published var isPurchaseComplete = false
    var updateListenerTask: Task<Void, Error>? = nil
    
    let storeService = StoreService()
    
    init(){
        updateListenerTask = listenForTransactions()
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    @MainActor
    func requestHerbals(productID:String) async {
        do{
            try await herbals = storeService.requestProduct(productID: productID)
        }catch{
            isLoading = false
            errorMessage = storeService.getErrorMessage(error: error)
        }
    }
    
    @MainActor
    func purchaseHerbals(cartItem:CartItem, herbals:[Product]) async {
        do{
            isLoading = true
            try await storeService.purchase(cartItem: cartItem, herbals: herbals)
            
            isPurchaseComplete = true
        }catch{
            isLoading = false
            errorMessage = storeService.getErrorMessage(error: error)
        }
        isLoading = false
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            
            for await result in Transaction.updates {
                do {
                    let transaction = try self.storeService.checkVerified(result)
                    await transaction.finish()
                } catch {
                    
                }
            }
        }
    }
}
