//
//  SettingHeaderView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/15.
//

import SwiftUI
import Kingfisher

struct SettingHeaderView: View {
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @Binding private var isImageUploadComplete:Bool
    
    let user:User
    
    init(user: User, isImageUploadComplete:Binding<Bool>) {
        self.user = user
        self._isImageUploadComplete = isImageUploadComplete
    }
    
    private func loadImage() {
        guard let selectedImage = selectedImage else { return }
        guard let uid = AuthViewModel().userSession?.uid else {
            return
        }
        ImageUploader.uploadImage(image: selectedImage) { imageUrl in
            COLLECTION_USER.document(uid).updateData(["profileImageURL":imageUrl]){_ in
                isImageUploadComplete = true
                AuthViewModel.shared.fetchUser()
                
            }
        }
    }
    
    var body: some View {
        HStack{
            Button(action: {
                showImagePicker.toggle()
            }) {
                if let profileImageURL = user.profileImageURL{
                    ZStack{
                        KFImage(URL(string: profileImageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width:60,height: 60)
                            .padding(.leading)
                            .clipShape(Circle())
                        Text("画像を変更")
                            .font(.system(size: 8))
                            .foregroundColor(.white)
                            .frame(width: 45,height: 15)
                            .background {
                                Color.black.opacity(0.6)
                            }
                            .offset(y:15)
                    }
                    
                }else{
                    ZStack(alignment: .center){
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(.systemGray3))
                            .padding(.leading)
                        Text("画像を変更")
                            .font(.system(size: 8))
                            .foregroundColor(.white)
                            .frame(width: 45,height: 15)
                            .background {
                                Color.black.opacity(0.6)
                            }
                            .offset(x:8,y:15)
                    }
                }
            }.sheet(isPresented: $showImagePicker,onDismiss: loadImage) {
                ImagePicker(image: $selectedImage)
            }
            Text("\(user.userName) 様")
                .font(.system(size: 20))
                .bold()
            Spacer()
        }
        .frame(height: 70)
        .background(.white)
    }
}


