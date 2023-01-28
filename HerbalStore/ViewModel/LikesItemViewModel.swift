//
//  LikesItemViewModel.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/19.
//

import Foundation

class LikesItemViewModel:ObservableObject {
    
    @Published var likesItems:[LikesItem] = []
    @Published var didlike:Bool = false
    @Published var isLoading:Bool = false
    
    init(){
        fetchLikesItem()
    }
    
    func saveLikesItem(id:String,image:String,name:String) {
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        let data = ["productID":id,"image":image,"name":name]
        COLLECTION_LIKES.document(uid).collection("likesItem").document(id).setData(data){_ in
            self.didlike = true
        }
    }
    
    func fetchLikesItem() {
        isLoading = true
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        COLLECTION_LIKES.document(uid).collection("likesItem").getDocuments { snapshot, error in
            if error != nil{
                self.isLoading = false
                return
            }
            guard let documents = snapshot?.documents else {
                self.isLoading = false
                return}
            self.likesItems = documents.compactMap({try? $0.data(as: LikesItem.self)})
            self.isLoading = false
            print("お気に入り受信○")
        }
    }
    
    //■お気に入り商品の削除(ProductDetailViewとSettingViewで使用)
    func deleteLikesItem(id:String) {
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        COLLECTION_LIKES.document(uid).collection("likesItem").document(id).delete(){_ in
            self.didlike = false
        }
    }
    
    func checkLikes(id:String) {
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        COLLECTION_LIKES.document(uid).collection("likesItem").document(id).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.didlike = true
            } else {
                self.didlike = false
            }
        }
    }
}
