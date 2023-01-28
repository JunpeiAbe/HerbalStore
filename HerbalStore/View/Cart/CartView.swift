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
    @ObservedObject var storeViewModel = StoreViewModel()
    
    var paymentPrice:Decimal{
        //各商品の金額(値段×個数)
        var total:Decimal = 0
        for item in cartItems {
            total += item.totalPrice
        }
        return total
    }
    
    var body: some View {
        ZStack{
            if storeViewModel.isLoading{
                LoadingIndicator().zIndex(1.0)
            }
            VStack{
                if cartItems.count > 0 {
                    List{
                        ForEach(cartItems,id: \.self){cartItem in
                            CartItemView(storeViewModel: storeViewModel, cartItem: cartItem)
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
                        .foregroundColor(Color(.systemGray4))
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
            .alert(Text("購入が完了しました"), isPresented: $storeViewModel.isPurchaseComplete) {
                Button("OK"){
                    storeViewModel.isPurchaseComplete = false
                }
            }
            .onReceive(storeViewModel.$errorMessage) {errorMessage in
                if errorMessage != nil {
                    self.showAlert.toggle()
                }
            }
            .alert(Text(storeViewModel.errorMessage ?? ""), isPresented: $showAlert) {
                Button("OK"){
                    storeViewModel.errorMessage = nil
                }
            }
        }
    }
    func removeFromCart(cartItem:CartItem) {
        viewContext.delete(cartItem)
        do {
            try viewContext.save()
        } catch {
            print("error:",error)
        }
    }
    
}


