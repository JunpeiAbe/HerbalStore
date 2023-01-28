//
//  EditAccountView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/15.
//

import SwiftUI

struct EditAccountView: View {
    
    @State var userName = ""
    @State var email = ""
    @Environment (\.dismiss) var dismiss
    @State var showAlert = false
    @State var showLogoutAlert = false
    @State var showDeleteAlert = false
    @State var isChangeUserNameComplete = false
    @EnvironmentObject var authViewModel:AuthViewModel
    
    private var buttonIsDisabled:Bool {
        return userName.isEmpty
    }
    
    let user:User
    
    init(user:User){
        self.user = user
        email = self.user.email
    }
    
    func saveUserName(userName:String) {
        guard let uid = AuthViewModel.shared.userSession?.uid else {
            return
        }
        COLLECTION_USER.document(uid).updateData(["userName":userName]){_ in
            
            authViewModel.fetchUser()
            isChangeUserNameComplete = true
        }
    }

    var body: some View {
        ZStack{
            if authViewModel.isLoading{
                LoadingIndicator().zIndex(1.0)
            }
            VStack{
                HStack{
                    Text("ログイン")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.leading)
                    Spacer()
                }
                VStack(alignment: .leading,spacing: 20){
            
                    VStack{
                        HStack(spacing: 20){
                            Image(systemName: "person.circle")
                            TextField(user.userName, text: $userName)
                        }
                        Divider()
                    }
                    
                    VStack{
                        HStack(spacing: 20){
                            Image(systemName: "envelope")
                            Text(user.email)
                            Spacer()
                        }
                        Divider()
                    }
                    NavigationLink {
                        ResetPasswordView(email: $email)
                    } label: {
                        VStack{
                            HStack(spacing: 20){
                                Image(systemName: "key")
                                Text("パスワードの再設定")
                                Spacer()
                                Image(systemName: "arrow.right")
                            }.foregroundColor(.black)
                            Divider()
                        }
                    }
                }.padding()
                
                
                Button("ログアウト"){
                    showLogoutAlert.toggle()
                }
                .alert("ログアウトしますか?",isPresented: $showLogoutAlert, actions: {
                    Button("キャンセル",role: .cancel,action: {})
                    Button("OK",action: {
                        authViewModel.signout()
                    })
                }, message: {})
                .frame(width: 200,height: 50)
                .bold()
                .foregroundColor(.white)
                .background {Color.blue}
                .cornerRadius(20)
                
                Spacer()
                
                Button("アカウントを削除する"){
                    showDeleteAlert.toggle()
                }
                .alert("本当にアカウントを削除しますか?",isPresented: $showDeleteAlert, actions: {
                    Button("キャンセル",role: .cancel,action: {})
                    Button("削除",role: .destructive,action: {
                        authViewModel.withdraw()
                    })
                }, message: {Text("データが削除されますが、よろしいですか？")})
                .frame(width: 200,height: 50)
                .foregroundColor(.white)
                .background {
                    Color(.systemPink)
                }
                .cornerRadius(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("アカウント")
            .alert(Text("アカウント情報を変更しました"), isPresented: $isChangeUserNameComplete) {
                Button("OK"){
                    isChangeUserNameComplete = false
                }
            }
            .onReceive(authViewModel.$errorMessage, perform: {errorMessage in
                if errorMessage != nil {
                    print("ログアウト or 退会")
                    self.showAlert.toggle()
                }
            })
            .alert(Text(authViewModel.errorMessage ?? ""), isPresented: $showAlert) {
                Button("OK"){
                    authViewModel.errorMessage = nil
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        saveUserName(userName: userName)
                    }) {
                        Text("変更する").bold(!buttonIsDisabled)
                    }
                    .foregroundColor(buttonIsDisabled ? Color.gray: Color.blue)
                    .disabled(buttonIsDisabled)
                }
            }
        }
    }
}

