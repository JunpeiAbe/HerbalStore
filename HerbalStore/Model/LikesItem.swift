//
//  Likes.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct LikesItem:Decodable,Identifiable {
    @DocumentID var id: String?
    let image:String
    let name:String
    let productID:String
}
