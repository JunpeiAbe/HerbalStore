//
//  AuthError.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/24.
//

import Foundation

enum AuthError:Error {
case networkError
case userNotFound
case invalidEmail
case emailAlreadyInUse
case wrongPassword
case userDisabled
case weakPassword
case requiresRecentLogin
case unknown
    
    var message:String {
        switch self{
            
        case .networkError:
            return "ネットワークに接続できません。電波状況の良いところで再度お試しください。"
        case .weakPassword:
            return "パスワードは6文字以上で設定してください"
        case .userNotFound:
            return "登録ユーザーが見つかりません"
        case .invalidEmail:
            return "正しくないメールアドレスの形式です。"
        case .emailAlreadyInUse:
            return "既に登録されているメールアドレスです。"
        case .wrongPassword:
            return "メールアドレス、もしくはパスワードが違います。"
        case .userDisabled:
            return "このアカウントは無効です。"
        case .requiresRecentLogin:
            return "再認証が必要です。ログアウト後、再度ログインしてください"
        case .unknown:
            return "エラーが起きました"
        }
    }
}
