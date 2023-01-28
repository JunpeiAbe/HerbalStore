//
//  CategoryItemView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/21.
//

import SwiftUI

struct CategoryItemView: View {
    
    let category:Category
    
    
    var body: some View {
        
//        Button(action: {
//            
//        }) {
            HStack(spacing: 10){
                if category.categoryImage.isEmpty == false{
                    Image(category.categoryImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30,height: 30)
                }
                
                Text(category.categoryName)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .frame(width: 180,height: 30)
            .padding([.top,.bottom],5)
            .padding(.horizontal,20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray,lineWidth: 1)
            )
        //}
    }
}

struct CategoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemView(category: .skin)
            .previewLayout(.sizeThatFits)
    }
}
