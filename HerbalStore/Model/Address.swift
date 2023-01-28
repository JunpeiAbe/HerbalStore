//
//  Address.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Address:Identifiable,Decodable {
    @DocumentID var id:String?
    let userName:String
    let cellphoneNumber:String
    let postalcode:String
    let prefecture:String
    let municipalities:String
    let chomeAndStreetAddress:String
    let apartmentName:String
}
