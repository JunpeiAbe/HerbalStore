//
//  Category.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/21.
//

import Foundation

enum Category:Codable,CaseIterable{
    
    case all //全て
    case skin //美肌
    case hair //髪の毛
    case sickness //不調
    case aging //老化
    case anemia //貧血
    case pregnant //妊娠
    case others //その他
    
    var categoryName: String{
        switch self{
            
        case .skin: return "美肌"
        case .hair: return "髪の健康"
        case .sickness: return "女性の不調"
        case .aging: return "アンチエイジング"
        case .anemia: return "貧血や冷え"
        case .pregnant: return "妊娠中・産後"
        case .others: return "その他"
        case .all: return "全ての商品"
        }
    }
    
    var categoryImage: String{
        switch self{
            
        case .skin:return "skin"
        case .hair:return "hair"
        case .sickness:return "sickness"
        case .aging:return "aging"
        case .anemia:return "anemia"
        case .pregnant:return "pregnant"
        case .others:return ""
        case .all: return ""
        }
    }
}
