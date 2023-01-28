//
//  AuthViewModel.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/17.
//

import Firebase
import SwiftUI

class AuthViewModel:ObservableObject{
    
    static let shared = AuthViewModel()
    
    @Published var didAuthenticationUser = false
    @Published var userSession:FirebaseAuth.User?
    @Published var currentUser:User?
    @Published var didSendResetPasswordLink = false
    @Published var isLoading = false
    private var tempCurrentUser:FirebaseAuth.User?
    
    @Published var errorMessage:String?
    
    init() {
        //初期値を持たせておかないと、アカウントがあってもuserSessionはnilとなり起動時に常にloginViewにいってしまう。
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
        errorMessage = nil
    }
    //ログイン
    func login(withEmail email:String, password:String) {
        
        self.errorMessage = nil
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result,error in
            if error != nil {
                self.isLoading = false
                self.errorMessage = self.loginErrorMessage(of: error!)
                return
            }
            guard let user = result?.user else {return}
            self.userSession = user
            self.fetchUser()
        }
    }
    
    func loginErrorMessage(of error:Error) -> String{
        var message = ""
        guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else {
            return message
        }
        switch errorCode {
        case .networkError: message = AuthError.networkError.message
        case .weakPassword: message = AuthError.weakPassword.message
        case .emailAlreadyInUse: message = AuthError.emailAlreadyInUse.message
        //case .wrongPassword: message = AuthError.wrongPassword.message
        case .userNotFound: message = AuthError.userNotFound.message
        default: message = AuthError.unknown.message
        }
        return message
    }
    
    //ユーザ登録
    func register(withEmail email:String, userName:String,password:String) {
        
        isLoading = true
        self.errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password){ result,error in
            if error != nil {
                self.isLoading = false
                self.errorMessage = self.registerErrorMessage(of: error!)
                return
            }
            
            guard let user = result?.user else {return}
            self.tempCurrentUser = user
            
            let data: [String: Any] = ["email":email,"userName":userName]
            
            COLLECTION_USER.document(user.uid).setData(data){_ in
                
                self.didAuthenticationUser = true
                self.userSession = self.tempCurrentUser
                self.fetchUser()
            }
        }
    }
    
    func registerErrorMessage(of error:Error) -> String{
        var message = ""
        guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else {
            return message
        }
        switch errorCode {
        case .networkError: message = AuthError.networkError.message
        case .weakPassword: message = AuthError.weakPassword.message
        case .emailAlreadyInUse: message = AuthError.emailAlreadyInUse.message
        default: message = AuthError.unknown.message
        }
        return message
    }
   
    //ユーザー情報の取得
    func fetchUser() {
        
        self.errorMessage = nil
        
        guard let uid = userSession?.uid else {return}
        
        COLLECTION_USER.document(uid).getDocument { snapshot, error in
            
            if error != nil {
                self.isLoading = false
                self.errorMessage = self.fetchUserErrorMessage(of: error!)
                return
            }
            
            guard let user = try? snapshot?.data(as: User.self) else {return}
            self.currentUser = user
            self.isLoading = false
        }
    }
    
    func fetchUserErrorMessage(of error:Error) -> String{
        var message = ""
        guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else {
            return message
        }
        switch errorCode {
        case .networkError: message = AuthError.networkError.message
        default: message = AuthError.unknown.message
        }
        return message
    }
    
    func resetPassword(withEmail email:String) {
        
        isLoading = true
        self.errorMessage = nil
        
        Auth.auth().sendPasswordReset(withEmail: email) {error in
            if error != nil {
                self.isLoading = false
                self.errorMessage = self.resetPasswordErrorMessage(of: error!)
            }
            
            self.isLoading = false
            self.didSendResetPasswordLink = true
        }
    }
    
    func resetPasswordErrorMessage(of error:Error) -> String{
        var message = ""
        guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else {
            return message
        }
        switch errorCode {
        case .networkError: message = AuthError.networkError.message
        case .userNotFound: message = AuthError.userNotFound.message
        case .invalidEmail: message = AuthError.invalidEmail.message
        default: message = AuthError.unknown.message
        }
        return message
    }
    
    //■ログアウト
    func signout() {
        do {
            self.isLoading = true
            self.errorMessage = nil
            try Auth.auth().signOut()
            userSession = nil
        }catch {
            let errorCode = AuthErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .networkError: errorMessage = AuthError.networkError.message
            default: errorMessage = AuthError.unknown.message
            }
            self.isLoading = false
        }
    }
    
    //■退会
    func withdraw(){
        self.isLoading = true
        self.errorMessage = nil
        guard let uid = userSession?.uid else {return}
        userSession?.delete{ error in
            if error != nil{
                self.isLoading = false
                self.errorMessage = self.withdrawErrorMessage(of: error!)
                return
            }else{
                COLLECTION_USER.document(uid).delete{_ in
                    self.isLoading = false
                    self.userSession = nil
                    
                }
            }
        }
    }

    
    func withdrawErrorMessage(of error:Error) -> String{
        var message = ""
        guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else {
            return message
        }
        switch errorCode {
        case .networkError: message = AuthError.networkError.message
        case .requiresRecentLogin: message = AuthError.requiresRecentLogin.message
        default: message = AuthError.unknown.message
        }
        return message
    }
}
