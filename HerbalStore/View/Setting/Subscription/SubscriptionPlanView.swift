//
//  SubscriptionPlanView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/16.
//

import SwiftUI
import StoreKit

struct SubscriptionPlanView: View {
    
    var subscription:SubscriptionPlan
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(subscription.product.displayName)
                    .font(.headline)
                    .bold()
                    .underline()
                Text("￥\(String(describing: subscription.product.price))円")
                    .padding([.top,.bottom],5)
                Spacer()
                Image(systemName: subscription.isChecked ? "checkmark.circle.fill":"circle")
                    .resizable()
                    .frame(width: 25,height: 25)
                    .foregroundColor(subscription.isChecked ? Color.pink:Color.gray)
            }
            Text(subscription.product.description)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: subscription.isChecked ? 5 : 2)
                .foregroundColor(subscription.isChecked ? Color.pink:Color.gray)
        )
        .padding(5)
    }
}

//struct SubscriptionPlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscriptionPlanView().previewLayout(.sizeThatFits)
//    }
//}
