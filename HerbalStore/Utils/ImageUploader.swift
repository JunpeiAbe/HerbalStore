//
//  ImageUploader.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/17.
//

import FirebaseStorage
import SwiftUI //UIImageがSwiftUIにないのでUikit

struct ImageUploader {
    static func uploadImage(image:UIImage, completion:@escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(fileName)")
        
        ref.putData(imageData,metadata: nil){ _ ,error in
            if error != nil{
                print("error is imageUpload")
                return
            }
            
            ref.downloadURL { url, _ in
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
            }
        }
    }
}
