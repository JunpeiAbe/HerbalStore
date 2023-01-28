//
//  ContactFormView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/15.
//

import SwiftUI

struct ContactFormView: View {
    
    var body: some View {
        VStack(spacing: 20){
            Text("問い合わせ先").font(.largeTitle).bold()
            Text("HerbalStoreのお問い合わせは下記問い合わせフォームより受け付けております。\n・３営業日以内にuihrsw0228@gmail.comから返答いたします。3営業日を過ぎても返答がない場合は、再度お問合せください。\n・お問合せの内容によってはお時間をいただく場合や解凍できない場合がございます。あらかじめご了承ください")
            Link("お問合せフォームはこちら", destination:URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdez3C7-pPEwhJipb7cfVXp3FF0Ll8MVkUjyPkyHkuixF9wRg/viewform?usp=sf_link")!).font(.headline)
        }.padding()
        
    }
}

struct ContactFormView_Previews: PreviewProvider {
    static var previews: some View {
        ContactFormView()
    }
}
