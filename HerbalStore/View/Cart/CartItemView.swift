//
//  CartItemView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/23.
//

import SwiftUI


struct CartItemView: View {
    
    @ObservedObject var storeViewModel:StoreViewModel
    @Environment(\.managedObjectContext) private var viewContext
    var cartItem:FetchedResults<CartItem>.Element
    
    var body: some View {
        HStack(spacing:10){
            HStack{
                Image(cartItem.image)
                    .resizable()
                    .frame(width: 70,height: 70)
                    .cornerRadius(20)
                    .shadow(color:Color(.systemGray3),radius: 5)
                
                VStack(alignment: .leading, spacing: 10){
                    
                    Text(cartItem.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Text("￥\(String(describing: cartItem.formattedPrice))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.leading)
                Spacer()
            }
             .frame(width: UIScreen.main.bounds.width * 0.50)
            
            
            VStack(spacing: 5) {
                HStack{
                    Button(action: {
                        if cartItem.formattedQuantity > 1{
                            cartItem.formattedQuantity -= 1
                            
                            do {
                                try viewContext.save()
                            }catch {
                                print("error:",error)
                            }
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.gray)
                    }
                    
                    Text(String(describing:cartItem.quantity))
                        .foregroundColor(.black)
                        .frame(width:20)
                        
                    Button(action: {
                        if cartItem.formattedQuantity < 10{
                            cartItem.formattedQuantity += 1
                            do {
                                try viewContext.save()
                            }catch {
                                print("error:",error)
                            }
                            
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.gray)
                    }
                }
                Button(action: {
                    Task{
                        await storeViewModel.requestProduct(productID:cartItem.id)
                        try await storeViewModel.purchase(cartItem: cartItem)
                    }
                }) {
                    Text("購入する")
                }
                .frame(width: 100,height: 40)
                .foregroundColor(.white)
                .background(Color.mint)
                .cornerRadius(20)
                .padding(10)
            }
            .buttonStyle(.plain)
            
            HStack(spacing: 0){
                Image(systemName: "trash")
                    .foregroundColor(.gray)
                Image(systemName:"greaterthan")
                    .font(.system(size: 8))
            }
        }
    }
}


