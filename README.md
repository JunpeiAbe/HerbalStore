## HerbalStore(生薬を購入するECアプリ)

<img width="650" alt="ポートフォリオ①" src="https://user-images.githubusercontent.com/89124336/235298451-eb1c4a3f-44fd-4551-9cb3-db65fcc149f7.png">

## ■概要

このアプリは、女性に特有の症状や悩みに有効な生薬を購入するためのECアプリです。

症状や悩みのカテゴリを選択することで、任意の商品リストを取得することができます。

ユーザーは複数の商品リストから商品を選択し、カートに保存することができます。

カートに追加した商品の購入や定期購入の課金機能をStorekitにて実装しています。

ユーザ情報・購入履歴・お気に入り商品はFirebaseで管理しています。お問い合わせフォームはGoogleFormにて作成しています。

このアプリは、MVVMパターンを採用して開発しており、SwiftUIを使用しています。

## ■仕様

・商品の選択・カートへの追加

・カートの管理(CoreData)

・購入や定期購入の課金機能の実装(Storekit, async/await対応)

・ユーザ情報・購入履歴・お気に入り商品の管理(CloudFirestore)

・お問い合わせフォーム(GoogleForm)

## ■使用技術

・言語: Swift(SwiftUI)

・データベース: CloudFirestore(NoSQL)、CoreData(SQLite)

・使用ツール・ライブラリ: Xcode,Github,SwiftPackageManager

## ■動作環境

Xcode 14.3

iOS 16.0

## ■連絡先

ご質問やご意見がある場合は、以下のメールアドレスにお問い合わせください。

開発者: takatuki4046@gmail.com

