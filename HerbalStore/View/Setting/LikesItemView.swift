//
//  LikedItemView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/11.
//

import SwiftUI

struct LikesItemView: View {
    
    @ObservedObject var likesItemViewModel:LikesItemViewModel
    
    init(likesItem:LikesItem){
        self.likesItemViewModel = LikesItemViewModel(likesItem: likesItem)
    }
    
    var body: some View {
        VStack{
            Image(likesItemViewModel.likesItem.image)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 140,height: 140)
                .shadow(color:Color(.systemGray3),radius: 5)
            HStack{
                Text(likesItemViewModel.likesItem.name)
                    .font(.footnote)
                    .bold()
                    
                Spacer()
                Button(action: {
                    if likesItemViewModel.didlike {
                        likesItemViewModel.deleteLikesItem(id: likesItemViewModel.likesItem.productID)
                    }else{
                        likesItemViewModel.saveLikesItem(id: likesItemViewModel.likesItem.productID, image: likesItemViewModel.likesItem.image, name: likesItemViewModel.likesItem.name)
                    }
                    
                }) {
                    Image(systemName: "heart.circle")
                        .foregroundColor(likesItemViewModel.didlike ? .pink:.gray)
                }.font(.title)
            }
            .padding([.horizontal,.bottom],15)
        }
        .frame(width: UIScreen.main.bounds.width * 0.4,height: UIScreen.main.bounds.height * 0.2)
        .padding(5)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 2)
        }
    }
}

