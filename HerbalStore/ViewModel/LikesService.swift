//
//  LikesService.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/29.
//

import Foundation

struct LikesService {
    //関数のみ定義
    //いいね機能
    func saveLikesItem(id:String,image:String,name:String,completion:@escaping(()->Void)) {
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        let data = ["productID":id,"image":image,"name":name]
        COLLECTION_LIKES.document(uid).collection("likesItem").document(id).setData(data){_ in
            completion()
        }
    }
    
    //いいね削除機能
    func deleteLikesItem(id:String,completion:@escaping(()->Void)) {
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        COLLECTION_LIKES.document(uid).collection("likesItem").document(id).delete(){_ in
            completion()
        }
    }
    
    //いいねのチェック機能
    func checkLikes(id:String,completion:@escaping((Bool)->Void)) {
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        COLLECTION_LIKES.document(uid).collection("likesItem").document(id).getDocument { snapshot, _ in
            guard let snapshot = snapshot else {return}
            completion(snapshot.exists)
        }
    }
    
    func fetchLikesItem(isLoading:@escaping(() -> Void),completion:@escaping(([LikesItem])->Void)) {
        
        var likesItems = [LikesItem]()
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        
        COLLECTION_LIKES.document(uid).collection("likesItem").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {
                isLoading()
                return
            }
            likesItems = documents.compactMap({try? $0.data(as: LikesItem.self)})
            completion(likesItems)
        }
    }
}
