//
//  MainTabView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/21.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedIndex = 0
    @EnvironmentObject var viewModel: AuthViewModel

    var tabTitle: String {
        switch selectedIndex {
        case 0: return "ホーム"
        case 1: return "カート"
        case 2: return "設定"
        default: return ""
        }
    }
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var cartItems: FetchedResults<CartItem>
        
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationView {
                TabView(selection: $selectedIndex){
                    
                    HomeView()
                        .onTapGesture {
                            selectedIndex = 0
                        }
                        .tabItem{
                            Image(systemName: "house")
                            Text("ホーム")
                        }
                        .tag(0)
                    CartView()
                        .onTapGesture {
                            selectedIndex = 1
                        }
                    .badge(cartItems.count > 0 ? cartItems.count: .zero)
                        .tabItem{
                            Image(systemName: "cart")
                            Text("カート")
                        }
                        .tag(1)
                    SettingView(user: user)
                        .onTapGesture {
                            selectedIndex = 2
                        }
                        .tabItem{
                            Image(systemName: "list.bullet")
                            Text("設定")
                        }
                        .tag(2)
                }
                .navigationTitle(tabTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if selectedIndex == 0{
                            Button {
                                selectedIndex = 1
                            } label: {
                                Image(systemName: "cart")
                                    .foregroundColor(Color.gray)
                                    .bold()
                            }
                        }
                    }
                }
            }
        }
    }
}

