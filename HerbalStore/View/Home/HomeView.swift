//
//  HomeView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/21.
//

import SwiftUI

struct HomeView: View {
    
    @State private var selectedCategory:Category = .all
    
    var body: some View {
        
        ScrollView(.vertical){
            VStack{
                FeaturedTabView()
                    .frame(height: UIScreen.main.bounds.width / 1.9)
                    .padding(.bottom, 10)
                HStack{
                    Text("商品カテゴリー")
                        .font(.footnote)
                        .foregroundColor(.mint)
                        .bold()
                        
                    Spacer()
                }.padding(.leading,10)
                
                CategoryGridView(selectedCategory: $selectedCategory)
                
                HStack{
                    Text("商品一覧")
                        .font(.footnote)
                        .foregroundColor(.mint)
                        .bold()
                        
                    Spacer()
                }.padding(.leading,10)
                
                LazyVGrid(columns: gridLayout,spacing: 15) {
                    ForEach(selectedHerbals(category: selectedCategory)) { herbal in
                        ProductItemView(herbal: herbal)
                    }
                }.padding([.horizontal,.top])
            }
        }
    }
    
    private func selectedHerbals(category:Category) -> [Herbal] {
        
        let selectedCategory:[Herbal]
        
        switch category {
        
        case .all:
            selectedCategory = herbals.filter{$0.category.contains(.all)}
        case .skin:
            selectedCategory = herbals.filter{$0.category.contains(.skin)}
        case .hair:
            selectedCategory = herbals.filter{$0.category.contains(.hair)}
        case .sickness:
            selectedCategory = herbals.filter{$0.category.contains(.sickness)}
        case .aging:
            selectedCategory = herbals.filter{$0.category.contains(.aging)}
        case .anemia:
            selectedCategory = herbals.filter{$0.category.contains(.anemia)}
        case .pregnant:
            selectedCategory = herbals.filter{$0.category.contains(.pregnant)}
        case .others:
            selectedCategory = herbals.filter{$0.category.contains(.others)}
        }
        return selectedCategory
    }
}


