//
//  FeaturedTabView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/21.
//

import SwiftUI

struct FeaturedTabView: View {
    
    init() {
            UIPageControl.appearance().currentPageIndicatorTintColor = .red
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.2)
        }
    
    var body: some View {
        TabView {
            ForEach(features) {feature in
                FeaturedItemView(feature: feature)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

struct FeaturedTabView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedTabView()
    }
}
