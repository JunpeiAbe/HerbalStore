//
//  CategoryGridView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/21.
//

import SwiftUI

struct CategoryGridView: View {
    
    //let categories:[Category]
    @Binding var selectedCategory:Category
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            LazyHGrid(rows: gridLayout,spacing: columnSpacing) {
                ForEach(Category.allCases,id: \.self){ category in
                    Button {
                        selectedCategory = category
                    } label: {
                        CategoryItemView(category: category)
                    }

                   
                }
            }
            .frame(height: 100)
            .padding(.horizontal,10)
            .padding(.vertical,5)
        }
    }
}

//struct CategoryGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryGridView(categories: [.all,.skin,.pregnant,.anemia,.others,.aging,.sickness,.hair])
//    }
//}
