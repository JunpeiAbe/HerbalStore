//
//  LikedItemView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/11.
//

import SwiftUI

struct LikesItemView: View {
    
    let likesItem:LikesItem
    @StateObject var likesItemViewModel = LikesItemViewModel()
    
    var body: some View {
        VStack{
            Image(likesItem.image)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 140,height: 140)
                .shadow(color:Color(.systemGray3),radius: 5)
            HStack{
                Text(likesItem.name)
                    .font(.footnote)
                    .bold()
                    
                Spacer()
                Button(action: {
                    if likesItemViewModel.didlike {
                        likesItemViewModel.deleteLikesItem(id: likesItem.productID)
                    }else{
                        likesItemViewModel.saveLikesItem(id: likesItem.productID, image: likesItem.image, name: likesItem.name)
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
        .onAppear(perform: {likesItemViewModel.checkLikes(id: likesItem.productID)})
    }
}

