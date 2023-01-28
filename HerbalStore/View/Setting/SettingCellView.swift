//
//  SettingCellView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/15.
//

import SwiftUI

struct SettingCellView: View {
    
    let settingCellViewModel:SettingCellViewModel
    
    var body: some View {
        VStack {
            HStack{
                Image(systemName:settingCellViewModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width:22,height: 22)
                    .padding(6)
                    .foregroundColor(Color(.systemGray3))
                Text(settingCellViewModel.title)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }.padding([.top,.horizontal])
            Divider()
                .padding(.leading)
        }.background(.white)
    }
}

enum SettingCellViewModel:Int, CaseIterable{
    case account
    case address
    case subscription
    case contact
    
    var title:String{
        switch self {
        case .account: return "アカウント"
        case .address: return "住所"
        case .subscription: return "定期購入"
        case .contact: return "お問合せ"
        }
    }
    var imageName:String {
        switch self{
        case .account: return "person.circle"
        case .address:return "mappin.circle"
        case .subscription: return "cart"
        case .contact: return "envelope"
        }
    }
}

