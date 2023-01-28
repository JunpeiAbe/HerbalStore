//
//  LoginView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/16.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var showAlert = false
    var buttonIsDisabled:Bool {
        return email.isEmpty || password.isEmpty
    }
    @EnvironmentObject var authViewModel:AuthViewModel
    
    var body: some View {
        
        ZStack{
            if authViewModel.isLoading{
                LoadingIndicator().zIndex(1.0)
            }
            NavigationView {
                VStack(spacing: 32) {
                    
                    Image("icon_image")
                        .resizable()
                        .frame(width: 200,height: 200)
                    Text("Herbal Store")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                    
                    CustomTextField(text: $email, title: "Email", placeholder: "name@example.com", isSecureField: false)
                    CustomTextField(text: $password, title: "パスワード", placeholder: "パスワードを入力してください",isSecureField: true)
                    
                    Button {
                        
                    } label: {
                        NavigationLink {
                            ResetPasswordView(email: $email)
                        } label: {
                            Text("パスワードを忘れた方はこちら")
                                .font(.system(size: 13,weight: .semibold))
                                .foregroundColor(.blue)
                                .padding(.top)
                        }
                    }.frame(maxWidth: .infinity,alignment: .trailing)
                    
                    Button {
                        authViewModel.login(withEmail: email, password: password)
                    } label: {
                        HStack{
                            Text("ログイン")
                                .foregroundColor(.white)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width:UIScreen.main.bounds.width - 32,height: 50)
                    .disabled(buttonIsDisabled)
                    .background(buttonIsDisabled ? Color.gray : Color.black)
                    .cornerRadius(10)
                    
                    Button {
                        
                    } label: {
                        NavigationLink {
                            RegisterView().navigationBarBackButtonHidden()
                        } label: {
                            HStack{
                                Text("アカウントを忘れた方はこちら")
                                    .font(.system(size: 14))
                                Text("Sign Up")
                                    .font(.system(size: 14,weight: .semibold))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            .onReceive(authViewModel.$errorMessage, perform: {errorMessage in
                if errorMessage != nil {
                    print("ログイン")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
