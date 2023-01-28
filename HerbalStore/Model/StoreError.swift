//
//  StoreError.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/25.
//

import Foundation

enum StoreError:Error {
    case userCancelled //ユーザーによって購入がキャンセルされた
    case pending //クレジットカードが未設定などの理由で購入が保留された
    case productUnavailable //指定した商品が無効
    case purchaseNotAllowed //OSの支払い機能が無効化されている
    case failedVerification //トランザクションデータの署名が不正
    case unknown //その他のエラー
    
}
