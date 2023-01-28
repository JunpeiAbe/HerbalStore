//
//  User.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/17.
//

import Foundation
import FirebaseFirestoreSwift

struct User:Decodable,Identifiable {
    @DocumentID var id: String?
    var userName:String
    let email:String
    var profileImageURL: String?
}
