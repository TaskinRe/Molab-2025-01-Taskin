//
//  AnimatedGradientBackground.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 15/04/2025.
//


import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: animateGradient ?
                              [Color("BackgroundStart"), Color("BackgroundEnd")] :
                              [Color("BackgroundEnd"), Color("BackgroundStart")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animateGradient)
        .onAppear {
            animateGradient.toggle()
        }
    }
}

struct AnimatedGradientBackground_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedGradientBackground()
    }
}
