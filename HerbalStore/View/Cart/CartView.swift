//
//  CartView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/21.
//

import SwiftUI

struct CartView: View {
        
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var cartItems: FetchedResults<CartItem>
    @State private var showAlert = false
    @ObservedObject private var cartViewModel = CartViewModel()
    
    private var paymentPrice:Decimal{
        
        var total:Decimal = 0
        for item in cartItems {
            total += item.totalPrice
        }
        return total
    }
    
    var body: some View {
        ZStack{
            if cartViewModel.isLoading{
                LoadingIndicator().zIndex(1.0)
            }
            VStack{
                if cartItems.count > 0 {
                    List{
                        ForEach(cartItems,id: \.self){cartItem in
                            CartItemView(cartViewModel: cartViewModel, cartItem: cartItem)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive, action: {
                                        removeFromCart(cartItem: cartItem)
                                    }) {
                                        Label("削除",systemImage: "trash")
                                    }.buttonStyle(.plain)
                                }
                        }
                    }.listStyle(.plain)
                }else {
                    Spacer()
                    Text("カートに追加された商品がありません")
                        .foregroundColor(Color(.systemGray3))
                    Spacer()
                }
                Divider()
                HStack{
                    Text("合計")
                    Spacer()
                    Text("￥\(String(describing: paymentPrice))")
                        .font(.title)
                        .fontWeight(.black)
                }.padding(20)
            }
            .alert(Text("購入が完了しました"), isPresented: $cartViewModel.isPurchaseComplete) {
                Button("OK"){
                    cartViewModel.isPurchaseComplete = false
                }
            }
            .onReceive(cartViewModel.$errorMessage) {errorMessage in
                if errorMessage != nil {
                    self.showAlert.toggle()
                }
            }
            .alert(Text(cartViewModel.errorMessage ?? ""), isPresented: $showAlert) {
                Button("OK"){
                    cartViewModel.errorMessage = nil
                }
            }
        }
    }
    
    func removeFromCart(cartItem:CartItem) {
        viewContext.delete(cartItem)
        do {
            try viewContext.save()
        } catch {
            
        }
    }
    
}


