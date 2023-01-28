//
//  StoreError.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/25.
//

import Foundation

enum StoreError:Error {
    case userCancelled
    case pending
    case productUnavailable
    case purchaseNotAllowed
    case failedVerification
    case unknown
}
