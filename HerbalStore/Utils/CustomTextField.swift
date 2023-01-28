//
//  CustomTextField.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/16.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text:String
    let title:String
    let placeholder:String
    var isSecureField:Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(title)
                .foregroundColor(.gray)
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField{
                SecureField(placeholder, text: $text)
                    .foregroundColor(.black)
            }else{
                TextField(placeholder, text: $text)
                    .foregroundColor(.black)
            }
            
            Divider()
        }
    }
}

