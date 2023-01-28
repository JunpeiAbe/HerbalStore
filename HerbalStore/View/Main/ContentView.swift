//
//  ContentView.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/09.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {

        Group{
            if authViewModel.userSession?.uid != nil {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
