//
//  SubscriptionView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/15.
//

import SwiftUI
import StoreKit

//現在のプランをわかるようにしたい→テキスト表示
struct SubscriptionView: View {
    
    @StateObject var storeViewModel:StoreViewModel
    @State var currentSubscription: Product?
    @State var status: Product.SubscriptionInfo.Status?
    @State var showAlert = false
    
    var period:String {
        guard let period = currentSubscription?.subscription?.subscriptionPeriod else {return ""}
        return "\(period.value)\(period.unit)"
    }
    
    //■チェックが1つの時のみ有効化する
    var buttonIsDisabled:Bool {
        
        let selectedPlan = storeViewModel.subscriptions.filter({$0.isChecked == true})
        
        if selectedPlan.count < 1 || selectedPlan.first?.id == currentSubscription?.id{
            return true //ボタンを押せない
        }else{
            return false //ボタンを押せる
        }
    }
    
    //■チェックが常に0か1つの状態をキープする, チェックされている状態で他をタップすればfalseになる。
    func checkValidation(storeViewModel:StoreViewModel,index:Int) {
        if storeViewModel.subscriptions.filter({$0.isChecked == true}).count < 1{
            storeViewModel.subscriptions[index].isChecked.toggle() //trueにする
        }else{
            storeViewModel.subscriptions[index].isChecked = false
        }
    }
    
    var body: some View {
        ZStack{
            if storeViewModel.isLoading{
                LoadingIndicator().zIndex(1.0)
            }
            ScrollView(.vertical){
                VStack{
                    Text("定期購入プラン")
                        .font(.title)
                        .bold()
                    if let currentSubscription = currentSubscription{
                        Text("現在のプラン")
                            .font(.footnote).foregroundColor(.gray)
                        HStack(spacing: 10){
                            Text(currentSubscription.displayName)
                            Text("\(currentSubscription.displayPrice) / \(period)")
                        }
                    }
                    if storeViewModel.subscriptions.count > 0{
                        ForEach(0..<storeViewModel.subscriptions.count) { index in
                            SubscriptionPlanView(subscription:storeViewModel.subscriptions[index])
                                .onTapGesture {
                                    checkValidation(storeViewModel: storeViewModel, index: index)
                                }
                        }
                        Text("プラン記載の期間に生薬のセットを定期配送いたします。\n※セット内容は季節によって変更します。")
                        Button("購入済みの商品を復元する"){
                            Task {
                                try? await AppStore.sync()
                            }
                        }
                        .bold()
                        .padding()
                        Text("購入後のお支払いはクレジットカードに請求されます。更新日時の24時間前までに解約しない限り、同期間・同料金で登録が自動更新されます。解約についての詳細は、Appleのサブスクリプションを解約する方法についてをご参照ください。利用期間中のプランのキャンセルは契約期間が終わった後にキャンセル処理が行われます。自動更新後の料金は、更新日時の24時間前までに請求されます。ご購入後の全額返金、および、残りの期間について月額、日割での返金には対応しておりません。アプリをアンインストール(削除)しても自動更新は解約されません。")
                            .font(.footnote)
                            .padding()
                        Button("購入する"){
                            guard let product = storeViewModel.subscriptions.filter({$0.isChecked == true}).first?.product else {return}
                            Task{
                                try await storeViewModel.purchase(product)
                            }
                        }
                        .disabled(buttonIsDisabled)
                        .frame(width: 200,height: 50)
                        .foregroundColor(.white)
                        .background {
                            buttonIsDisabled ? Color.gray : Color(.systemPink)
                        }
                        .cornerRadius(20)
                    }
                }
                .navigationTitle("定期購入")
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                Task {
                    await updateSubscriptionStatus()
                }
            }
            .onChange(of: storeViewModel.purchasedSubscriptions) { _ in
                Task {
                    await updateSubscriptionStatus()
                }
            }
            .onReceive(storeViewModel.$errorMessage) {errorMessage in
                if errorMessage != nil {
                    self.showAlert.toggle()
                }
            }
            .alert(Text(storeViewModel.errorMessage ?? ""), isPresented: $showAlert) {
                Button("OK"){
                    storeViewModel.errorMessage = nil
                }
            }
            .alert(Text("購入が完了しました。"), isPresented: $storeViewModel.isPurchaseComplete) {
                Button("OK"){
                    storeViewModel.isPurchaseComplete = false
                }
            }
        }
    }
    
    @MainActor
    func updateSubscriptionStatus() async {
        do {
            guard let product = storeViewModel.subscriptions.map({$0.product}).first,
                  let statuses = try await product.subscription?.status else {
                return
            }
            
            print("updateSubscriptionStatus",product) //productを取る意味は????

            var highestStatus: Product.SubscriptionInfo.Status? = nil
            var highestProduct: Product? = nil

            for status in statuses {
                switch status.state {
                case .expired, .revoked: //期限切れ(.expired)、解約(.revoke)
                    continue
                default:
                    let renewalInfo = try storeViewModel.checkVerified(status.renewalInfo)

                    guard let newSubscription = storeViewModel.subscriptions.map({$0.product}).first(where: { $0.id == renewalInfo.currentProductID }) else {
                        continue
                    }

                    guard let currentProduct = highestProduct else {
                        highestStatus = status
                        highestProduct = newSubscription
                        continue
                    }

                    let highestTier = storeViewModel.tier(for: currentProduct.id)
                    let newTier = storeViewModel.tier(for: renewalInfo.currentProductID)

                    if newTier > highestTier {
                        highestStatus = status
                        highestProduct = newSubscription
                    }
                }
            }

            status = highestStatus
            currentSubscription = highestProduct
            
        } catch {
            print("Could not update subscription status \(error)")
        }
    }
}
    
