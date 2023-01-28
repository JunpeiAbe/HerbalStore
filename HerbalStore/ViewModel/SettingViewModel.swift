//
//  SettingViewModel.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/29.
//

import Foundation

class SettingViewModel:ObservableObject {
    
    @Published var likesItems:[LikesItem] = []
    @Published var purchasedItems:[PurchasedItem] = []
    @Published var didlike = false
    @Published var isLoading = false
    
    let likesService = LikesService()
    let storeService = StoreService()
    
    init(){
        fetchLikesItems()
        fetchPurchasedItems()
    }
    
    func fetchPurchasedItems(){
        isLoading = true
        storeService.fetchPurchasedItem {
            self.isLoading = false
        } completion: { purchasedItems in
            self.purchasedItems = purchasedItems
            self.isLoading = false
        }
    }
    
    func fetchLikesItems(){
        isLoading = true
        likesService.fetchLikesItem {
            self.isLoading = false
        } completion: { likesItems in
            self.likesItems = likesItems
            self.isLoading = false
        }
    }
}
