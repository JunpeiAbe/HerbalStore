//
//  Constant.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/09.
//

import SwiftUI
import FirebaseFirestore


//■何度も使用する値や記述をまとめてある。
let columnSpacing:CGFloat = 10
let rowSpacing:CGFloat = 10
var gridLayout:[GridItem] {
    return Array(repeating: GridItem(.flexible(),spacing: rowSpacing), count: 2)
}

let COLLECTION_USER = Firestore.firestore().collection("users")
let COLLECTION_ADDRESS = Firestore.firestore().collection("address")
let COLLECTION_LIKES = Firestore.firestore().collection("likes")
let COLLECTION_PURCHASED = Firestore.firestore().collection("purchased")

