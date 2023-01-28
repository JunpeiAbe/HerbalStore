//
//  RegisterView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/16.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var userName = ""
    @State private var showAlert = false
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var authViewModel:AuthViewModel
    
    var buttonIsDisabled:Bool {
        return email.isEmpty || password.isEmpty || userName.isEmpty
    }
    
    var body: some View {
        ZStack{
            if authViewModel.isLoading{
                LoadingIndicator().zIndex(1.0)
            }
            VStack(spacing: 20) {
                VStack(alignment: .leading){
                    Button {
                        dismiss()
                    } label:{
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .imageScale(.medium)
                            .padding()
                    }
                    Text("新規アカウントを\n作成する")
                        .font(.system(size: 40))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .frame(width: 350)
                    
                }.foregroundColor(.black)
                
                VStack(spacing: 50){
                    CustomTextField(text: $userName, title: "ユーザーネーム", placeholder: "ユーザーネームを入力してください", isSecureField: false)
                    CustomTextField(text: $email, title: "Email", placeholder: "name@example.com", isSecureField: false)
                    CustomTextField(text: $password, title: "パスワード", placeholder: "パスワードを入力してください",isSecureField: true)
                }
                .padding(.horizontal)
                
                Button {
                    authViewModel.register(withEmail: email, userName: userName, password: password)
                } label: {
                    HStack{
                        Text("ユーザー登録")
                            .foregroundColor(.white)
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                }
                .frame(width:UIScreen.main.bounds.width - 32,height: 50)
                .disabled(buttonIsDisabled)
                .background(buttonIsDisabled ? Color.gray : Color.black)
                .cornerRadius(10)
                .padding(.top,20)
                Spacer()
            }
            .onReceive(authViewModel.$errorMessage, perform: {errorMessage in
                if errorMessage != nil {
                    print("登録")
                    self.showAlert.toggle()
                }
            })
            .alert(Text(authViewModel.errorMessage ?? ""), isPresented: $showAlert) {
                Button("OK"){
                    authViewModel.errorMessage = nil
                }
            }
        }
    }
}


