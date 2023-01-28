//
//  FeaturedItemView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/21.
//

import SwiftUI

struct FeaturedItemView: View {
    
    let feature:Feature
    
    var body: some View {
        HStack{
            Image(feature.image)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.4,height: UIScreen.main.bounds.width * 0.4)
            VStack{
                Text(feature.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .underline()
                Text(feature.text).font(.caption).padding(.top,3)
            }.frame(width: UIScreen.main.bounds.width * 0.45,height: UIScreen.main.bounds.width * 0.4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray,lineWidth: 1)
                .shadow(color: Color(.systemGray), radius: 5)
        )
        
        .padding(.horizontal,10)
    }
}

struct FeaturedItemView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedItemView(feature: features[5])
    }
}
