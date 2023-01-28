//
//  PurchasedItemView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/11.
//

import SwiftUI

struct PurchasedItemView: View {
    
    let purchasedItem: PurchasedItem
    
    var body: some View {
        HStack(spacing: 10){
            HStack{
                Image(purchasedItem.image)
                    .resizable()
                    .frame(width: 70,height: 70)
                    .cornerRadius(20)
                    .shadow(color:Color(.systemGray3),radius: 5)
                
                VStack(alignment: .leading, spacing: 10){
                    Text(purchasedItem.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text("× \(String(describing: purchasedItem.quantity))")
                }
                .padding(.leading)
                Spacer()
            }
            
            Spacer()
            VStack(alignment: .trailing){
                Text("￥\(String(describing:purchasedItem.totalPrice))")
                Text(purchasedItem.timestampString)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
            
        }
    }
}

