//
//  Extensions.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/16.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

