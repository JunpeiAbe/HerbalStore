//
//  PurchaseRecordView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/21.
//

import SwiftUI

enum SettingFilterOptions:Int,CaseIterable {
    case purchased
    case likes
    
    var title: String {
        switch self {
        case .purchased: return "購入履歴"
        case .likes: return "お気に入り"
        }
    }
}

struct SettingView: View {
    
    @StateObject var storeViewModel = StoreViewModel()
    @StateObject var likesItemViewModel = LikesItemViewModel()
    @State var selectedOption: SettingFilterOptions = .purchased
    @State var isImageUploadComplete = false
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        ZStack{
            if likesItemViewModel.isLoading || storeViewModel.isLoading{
                LoadingIndicator().zIndex(1.0)
            }
            VStack{
                
                SettingHeaderView(user: user, isImageUploadComplete: $isImageUploadComplete)
                
                ForEach(SettingCellViewModel.allCases,id: \.self) { viewModel in
                    NavigationLink {
                        switch viewModel {
                        case .account:
                            EditAccountView(user: user)
                        case .address:
                            EditAddressView()
                        case .subscription:
                            SubscriptionView(storeViewModel: storeViewModel)
                        case .contact:
                            ContactFormView()
                        }
                    } label: {
                        SettingCellView(settingCellViewModel: viewModel)
                            
                    }
                }
                
                HStack(spacing: 20){
                    Button(action: {
                        selectedOption = .purchased
                        storeViewModel.fetchPurchasedItem()
                    }) {
                        Text("購入履歴")
                            .bold()
                    }
                    .padding(10)
                    .frame(width: UIScreen.main.bounds.width * 0.4)
                    .background(
                        Color(.systemGray6).opacity(0.7).cornerRadius(10)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 10).stroke(Color.black,lineWidth: 1)
                    )
                    
                    Button(action: {
                        selectedOption = .likes
                        likesItemViewModel.fetchLikesItem()
                    }) {
                        Text("お気に入り")
                            .foregroundColor(.pink)
                            .bold()
                    }
                    .padding(10)
                    .frame(width: UIScreen.main.bounds.width * 0.4)
                    .background(
                        Color(.systemGray6).opacity(0.7).cornerRadius(10)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black,lineWidth: 1)
                    )
                }
                
                if selectedOption == .likes {
                    if likesItemViewModel.likesItems.isEmpty {
                        VStack{
                            Text("お気に入りがありません")
                                .foregroundColor(Color.primary)
                            Spacer()
                        }.padding(.top)
                    }else{
                        ScrollView(.vertical){
                            LazyVGrid(columns: gridLayout,spacing: 15) {
                                ForEach(likesItemViewModel.likesItems) {likesItem in
                                    LikesItemView(likesItem: likesItem)
                                }
                            }.padding([.horizontal,.top])
                        }
                    }
                    
                }else if selectedOption == .purchased{
                    if storeViewModel.purchasedItems.isEmpty{
                        VStack{
                            Text("購入履歴がありません")
                                .foregroundColor(Color.primary)
                            Spacer()
                        }.padding(.top)
                    }else{
                        List{
                            ForEach(storeViewModel.purchasedItems) { purchasedItem in
                                PurchasedItemView(purchasedItem: purchasedItem)
                            }
                        }.listStyle(.plain)
                    }
                }
            }
            .padding(.top,20)
        }
        .alert("プロフィール画像を変更しました", isPresented: $isImageUploadComplete, actions: {
            Button("OK"){
                isImageUploadComplete = false
            }
        })
        .onAppear(perform: {
            likesItemViewModel.fetchLikesItem()
            storeViewModel.fetchPurchasedItem()
        })
    }
}


