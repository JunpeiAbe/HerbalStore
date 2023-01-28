//
//  ResetPasswordView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/16.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @State private var showAlert = false
    @Binding private var email: String
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var authViewModel:AuthViewModel
    
    private var buttonIsDisabled:Bool {
        return email.isEmpty
    }
    
    init(email: Binding<String>) {
        self._email = email
    }
    
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $email, title: "Email", placeholder: "現在のメールアドレスを入力してください", isSecureField: false)
            
            Button(action: {
                authViewModel.resetPassword(withEmail: email)
            }) {
                Text("パスワードリセットのリンクを送信")
                
                    .foregroundColor(.white)
            }
            .disabled(buttonIsDisabled)
            .frame(width:UIScreen.main.bounds.width - 32,height: 50)
            .background(buttonIsDisabled ? Color.gray : Color.black)
            .cornerRadius(10)
            
        }
        .padding(.horizontal)
        .onReceive(authViewModel.$didSendResetPasswordLink) { _ in
            self.dismiss()
        }
    }
}

