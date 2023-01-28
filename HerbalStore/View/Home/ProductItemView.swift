//
//  ProductItemView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/09.
//

import SwiftUI

struct ProductItemView: View {
    
    let herbal:Herbal
   
    var body: some View {
        NavigationLink(destination: ProductDetailView(herbal: herbal)) {
            VStack{
                Image(herbal.image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding(.horizontal,10)
                    .shadow(color:Color(.systemGray3),radius: 5)
                    
                Text(herbal.name)
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundColor(.mint)
                
                Text("￥\(String(describing: herbal.price))")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.bottom,10)
            }
            .frame(width: UIScreen.main.bounds.width * 0.4,height: UIScreen.main.bounds.height * 0.3)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray3), lineWidth: 1)
                    .shadow(color: Color(.systemGray), radius: 5)
            }
        }
    }
}

