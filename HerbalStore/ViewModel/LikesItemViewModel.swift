//
//  LikesItemViewModel.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/19.
//

import Foundation

class LikesItemViewModel:ObservableObject {
    
    @Published var likesItem:LikesItem
    @Published var didlike = false
    
    let likesService = LikesService()
    
    init(likesItem:LikesItem){
        self.likesItem = likesItem
        checkLikes(id: self.likesItem.id ?? "")
    }
    
    func saveLikesItem(id:String,image:String,name:String){
        likesService.saveLikesItem(id: id, image: image, name: name) {
            self.didlike = true
        }
    }
    
    func deleteLikesItem(id:String){
        likesService.deleteLikesItem(id: id) {
            self.didlike = false
        }
    }
    
    func checkLikes(id:String){
        likesService.checkLikes(id: id) { didlike in
            if didlike{
                self.didlike = true
            }else{
                self.didlike = false
            }
        }
    }
    
    var likesItemImage:String {
        return LikesItemViewModel(likesItem: likesItem).likesItem.image
    }
    
}
