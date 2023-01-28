//
//  EditAccountViewModel.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/19.
//

import Foundation
import SwiftUI

class EditAccountViewModel:ObservableObject {
    
    var user:User
    
    init(user:User){
        self.user = user
    }
    
    //■プロフィール画像の登録
    func saveUserInfo(_ image: UIImage,userName:String) {
        guard let uid = AuthViewModel().userSession?.uid else {
            print("User is nil")
            return
        }
        ImageUploader.uploadImage(image: image) { imageUrl in
            COLLECTION_USER.document(uid).updateData(["userName":userName,"profileImageURL":imageUrl]){_ in
                self.user.profileImageURL = imageUrl
                self.user.userName = userName
                print("変更完了")
            }
        }
    }
    //■ユーザーネームの変更
}
