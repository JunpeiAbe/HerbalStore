//
//  LodingIndicator.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/25.
//

import SwiftUI

struct LoadingIndicator: View {
    
    @State var isAnimating = false
    
    var body: some View {
        ZStack{
//            Color(.black)
//                .opacity(0.01)
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                .edgesIgnoringSafeArea(.all)
            Color(.gray)
                .frame(width: 150,height: 150)
                .cornerRadius(10)
                .opacity(0.1)
            VStack{
                Spacer()
                Circle()
                    .trim(from:0, to:0.6)
                    .stroke(AngularGradient(gradient: Gradient(colors: [.blue,.white]), center: .center), style:StrokeStyle(lineWidth: 8,lineCap:  .round))
                    .frame(width: 50,height: 50)
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0))
                    .onAppear(){
                        withAnimation (
                            Animation
                                .linear(duration: 0.8)
                                //.easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: false)){
                                    self.isAnimating = true
                                }
                    }
                    .onDisappear(){
                        self.isAnimating = false
                    }
                Text("Loading...")
                    .foregroundColor(.blue)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .padding(.top)
                Spacer()
            }
        }
        .frame(width: 200,height: 200)
        .background {
            Color.clear
        }
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}
