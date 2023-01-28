//
//  Purchased.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PurchasedItem:Decodable,Identifiable {
    @DocumentID var id:String?
    let image:String
    let name:String
    let price:Decimal
    let quantity:Decimal
    let date:Timestamp
    let userID:String
    
    var totalPrice: Decimal {
        return price * quantity
    }
    
    var timestampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date.dateValue())
    }
}
