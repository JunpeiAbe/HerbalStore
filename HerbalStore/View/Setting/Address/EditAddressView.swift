//
//  EditAddressView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/15.
//

import SwiftUI

struct EditAddressView: View {
    
    @Environment (\.dismiss) var dismiss
    @State var userName:String = ""
    @State var cellphoneNumber:String = ""
    @State var postalcode:String = ""
    @State var prefecture:String = ""
    @State var municipalities:String = ""
    @State var chomeAndStreetAddress:String = ""
    @State var apartmentName:String = ""
    
    @ObservedObject var editAddressViewModel = EditAddressViewModel()
    
    var buttonIsDisabled:Bool {
        return userName.isEmpty || cellphoneNumber.isEmpty || postalcode.isEmpty || prefecture.isEmpty || municipalities.isEmpty || chomeAndStreetAddress.isEmpty || apartmentName.isEmpty
    }
    
    var body: some View {
        ZStack{
            if editAddressViewModel.isLoading{
                LoadingIndicator().zIndex(1.0)
            }
            VStack(alignment: .leading){
                List{
                    Section(content: {
                        EditAddressCellView(text: $userName, addressField: .name)
                        EditAddressCellView(text: $cellphoneNumber, addressField: .cellphoneNumber)
                        EditAddressCellView(text: $postalcode, addressField: .postalcode)
                        EditAddressCellView(text: $prefecture, addressField: .prefecture)
                        EditAddressCellView(text: $municipalities, addressField: .municipalities)
                        EditAddressCellView(text: $chomeAndStreetAddress, addressField: .chomeAndStreetAddress)
                        EditAddressCellView(text: $apartmentName, addressField: .apartmentName)
                    }, header: {
                        Text("請求先情報")
                        .foregroundColor(.gray)
                    }, footer: {
                        Text("請求先情報は、郵送以外の目的では使用しません。")
                            .foregroundColor(.gray)
                    })
                }
                .listStyle(.automatic)
            }
            .navigationTitle("郵送先情報")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem{
                    Button("保存"){
                        editAddressViewModel.saveUserAddress(
                            userName: userName,
                            cellphoneNumber: cellphoneNumber,
                            postalcode: postalcode,
                            prefecture: prefecture,
                            municipalities: municipalities,
                            chomeAndStreetAddress: chomeAndStreetAddress,
                            apartmentName: apartmentName)
                    }
                    .foregroundColor(buttonIsDisabled ? .gray : .blue)
                    .disabled(buttonIsDisabled)
                }
            }.onAppear(perform: {
                editAddressViewModel.fetchUserAddress(completion: {
                    userName = editAddressViewModel.address.userName
                    cellphoneNumber = editAddressViewModel.address.cellphoneNumber
                    postalcode = editAddressViewModel.address.postalcode
                    prefecture = editAddressViewModel.address.prefecture
                    municipalities = editAddressViewModel.address.municipalities
                    chomeAndStreetAddress = editAddressViewModel.address.chomeAndStreetAddress
                    apartmentName = editAddressViewModel.address.apartmentName
                })
                
            })
        }
        .alert("住所を変更しました。", isPresented: $editAddressViewModel.isAddressUploadComplete, actions: {
            Button("OK"){
                editAddressViewModel.isAddressUploadComplete = false
            }
        })
    }
}


