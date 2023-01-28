//
//  SafariView.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/16.
//

import SwiftUI
import SafariServices

//https://docs.google.com/forms/d/e/1FAIpQLSdez3C7-pPEwhJipb7cfVXp3FF0Ll8MVkUjyPkyHkuixF9wRg/viewform?usp=sf_link

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.dismissButtonStyle = .done //閉じるボタンの形式を変更できる
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<Self>) {
        return
    }
}
