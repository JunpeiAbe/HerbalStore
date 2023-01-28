//
//  Feature.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/21.
//

import SwiftUI

struct Feature:Codable,Identifiable{
    let id:Int
    let image:String
    let title:String
    let text:String
}

let features:[Feature] = [
    Feature(id: 1, image: "skin", title: "美肌", text: "肌の美しさには「血」が関係します。良い肌には外からのケアだけでなくカラダの内側からのアプローチがかかせません。"),
    Feature(id: 2, image: "hair", title: "髪の健康", text: "髪は「血の余り」。五臓では「腎」が髪に関係します。また髪にといって頭皮は畑の土のようなもの。清潔で健康な頭皮の状態を保つことも大切です。"),
    Feature(id: 3 , image: "sickness", title: "女性の不調", text: "女性特有のお悩みは、「血」に関するものが多くあります。血が滞っている状態である「瘀血」は、生理痛や筋腫、生理不順などの原因となります。"),
    Feature(id: 4, image: "anemia", title: "貧血・冷え", text: "女性に多い、貧血と冷えの症状。貧血といわれたことがなくても、血の質や量が十分でなければ東洋医医学的には「血虚」かもしれません。"
            
),
    Feature(id: 5, image: "pregnant", title: "妊娠・産後", text: "妊娠、出産は、女性の体を大きく変える、人生の大イベントです。妊娠中のトラブルや産後の心や体をケアするのに、薬膳食材はお母さんたちのお役に立つことでしょう。"),
    Feature(id: 6, image: "aging", title: "アンチエイジング", text: "どんな人でも必ず年々年を重ねていきます。それでも少しでも老化は遅らせて、生き生きと美しくいたいもの。お肌や髪のツヤを保つのに潤いを与える「滋陰」の働きのある食材を取ることをおすすめします。"),
    
]


