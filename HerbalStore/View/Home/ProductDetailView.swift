//
//  ProductDetailView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/09.
//

import SwiftUI

struct ProductDetailView: View {
    
    @State private var quantity: Decimal = 0
    @Environment (\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var productDetailViewModel = ProductDetailViewModel()
    
    let herbal:Herbal
    
    var body: some View {
        VStack(alignment: .center){
            VStack(alignment: .leading,spacing: 10){
                Text(herbal.name)
                    .font(.title)
                    .fontWeight(.bold)
                Text(herbal.headline)
                    .font(.headline)
                    .foregroundColor(.white)
            }.padding(.top,50)
            HStack(spacing: 30){
                VStack(alignment: .leading,spacing: 5){
                    Text("価格(kg)")
                        .fontWeight(.semibold)
                    Text("￥\(String(describing: herbal.price))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Image(herbal.image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 200)
                    .shadow(radius: 10)
                
            }
            .offset(y:-30)
            .zIndex(1)
            
            VStack(alignment: .center){
                ScrollView(.vertical,showsIndicators: false){
                    Text(herbal.description)
                        .font(.system(.body, design: .rounded))
                        .frame(alignment: .topLeading)
                        .foregroundColor(.gray)
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top,-75)
                Divider()
                HStack{
                    Button(action: {
                        if quantity > 0{
                            quantity -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle")
                    }
                    
                    Text("\(String(describing: quantity))")
                    
                    Button(action: {
                        if quantity < 10 {
                            quantity += 1
                        }
                    }) {
                        Image(systemName: "plus.circle")
                    }
                    Spacer()
                    
                    Button(action: {
                        if productDetailViewModel.didlike {
                            productDetailViewModel.deleteLikesItem(id: herbal.id)
                        }else{
                            productDetailViewModel.saveLikesItem(id: herbal.id, image: herbal.image, name: herbal.name)
                        }
                    }) {
                        Image(systemName: "heart.circle")
                            .foregroundColor(
                                productDetailViewModel.didlike ? .pink:.gray
                            )
                    }
                }
                .font(.system(.title, design: .rounded))
                .foregroundColor(.black)
                .imageScale(.large)
                .padding(.horizontal,10)
                
                Button(action: {
                    if quantity > 0 {
                        addToCart(herbal: herbal, quantity: quantity)
                        dismiss()
                    }
                }) {
                    Text("\(Image(systemName: "cart"))カートに追加する")
                        .font(.system(.title2,design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(20)
                .frame(width: UIScreen.main.bounds.width - 30)
                .background(
                    LinearGradient(colors: [Color.pink,Color.orange], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
                .shadow(radius: 5)
                .padding(.bottom, 20)
            }
            .background(
                Color.white
                    .clipShape(CustomShape())
                    .padding(.top,-150)
            )
            .ignoresSafeArea()
        }.background(
            
            LinearGradient(colors: [Color.mint,Color.white], startPoint: .top, endPoint: .bottom)
        )
        .onAppear(
            perform: {
                productDetailViewModel.checkLikes(id: herbal.id)
            }
        )
    }
    
    private func addToCart(herbal:Herbal, quantity:Decimal) {
        let newItem = CartItem(context: viewContext)
        newItem.id = herbal.id
        newItem.image = herbal.image
        newItem.name = herbal.name
        newItem.price = herbal.price as NSDecimalNumber
        newItem.quantity = quantity as NSDecimalNumber
        do {
            try viewContext.save()
        } catch {
            
        }
        
    }
    
}


