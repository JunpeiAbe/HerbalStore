//
//  EditAddressCellView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/15.
//

import SwiftUI

struct EditAddressCellView: View {
    
    @Binding var text:String 
    let addressField:AddressField
    
    var body: some View {
        HStack{
            Text(addressField.title)
            TextField("必須", text: $text)
                .foregroundColor(.blue)
                .multilineTextAlignment(.trailing)
                .padding()
                .keyboardType(addressField.keyboard)
        }.padding(.horizontal)
        
    }
}

enum AddressField:Int,CaseIterable {
    case name
    case cellphoneNumber
    case postalcode
    case prefecture
    case municipalities
    case chomeAndStreetAddress
    case apartmentName
    
    var title:String {
        switch self {
        case .name: return "名前"
        case .cellphoneNumber: return "携帯番号"
        case .postalcode: return "郵便番号"
        case .prefecture: return "都道府県"
        case .municipalities: return "市区町村"
        case .chomeAndStreetAddress: return "丁目/番地"
        case .apartmentName:return "マンション名等"
        }
    }
    
    var keyboard:UIKeyboardType {
        switch self{
            
        case .cellphoneNumber:return .phonePad
        case .postalcode:return .numberPad
        case .name,.prefecture,.municipalities,.chomeAndStreetAddress,.apartmentName: return .default

        }
    }
}


