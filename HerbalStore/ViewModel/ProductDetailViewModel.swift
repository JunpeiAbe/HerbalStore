//
//  ProductDetailViewModel.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/29.
//

import Foundation

class ProductDetailViewModel:ObservableObject {
    
    @Published var didlike = false
    let likesService = LikesService()
    
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
}
