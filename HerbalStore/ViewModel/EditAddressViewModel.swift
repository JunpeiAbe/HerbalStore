//
//  EditAddressViewModel.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/18.
//

import Foundation
import Firebase

class EditAddressViewModel:ObservableObject {
    
    @Published var address:Address = Address(userName: "", cellphoneNumber: "", postalcode: "", prefecture: "", municipalities: "", chomeAndStreetAddress: "", apartmentName: "")
    @Published var isLoading: Bool = false
    @Published var isAddressUploadComplete = false
    
    
    init() {}
    //■現在の保存情報をキャッチ
    func fetchUserAddress(completion:(@escaping () -> Void)) {
        isLoading = true
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        COLLECTION_ADDRESS.document(uid).getDocument { snapshot, error in
            if error != nil {
                self.isLoading = false
                return
            }
            guard let address = try? snapshot?.data(as: Address.self) else {
                self.isLoading = false
                return}
            self.address = address
            self.isLoading = false
            print("fetchUserAddress")
            completion()
        }
    }
    //■住所を保存
    func saveUserAddress(userName:String,cellphoneNumber:String,postalcode:String,prefecture:String,municipalities:String,chomeAndStreetAddress:String,apartmentName:String){
        
        guard let uid = AuthViewModel.shared.userSession?.uid else {return}
        isLoading = true
        
        COLLECTION_ADDRESS.document(uid).setData(
             [
              "userName":userName,
              "cellphoneNumber":cellphoneNumber,
              "postalcode":postalcode,
              "prefecture":prefecture,
              "municipalities":municipalities,
              "chomeAndStreetAddress":chomeAndStreetAddress,
              "apartmentName":apartmentName
            ]
        )
        isLoading = false
        isAddressUploadComplete = true
    }
}
