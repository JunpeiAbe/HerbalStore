//
//  PurchasedItem+CoreDataProperties.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/09.
//
//

import Foundation
import CoreData


extension PurchasedItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PurchasedItem> {
        return NSFetchRequest<PurchasedItem>(entityName: "PurchasedItem")
    }

    @NSManaged public var name: String
    @NSManaged public var image: String
    @NSManaged public var price: NSDecimalNumber
    @NSManaged public var quantity: NSDecimalNumber
    
    public var formattedPrice:Decimal { price as Decimal }
    public var formattedQuantity:Decimal {
        get{
            quantity as Decimal
        }
        set{
            quantity = newValue as NSDecimalNumber
        }
    }
    
    public var totalPrice: Decimal {
        return formattedPrice * formattedQuantity
    }

}

extension PurchasedItem : Identifiable {

}
