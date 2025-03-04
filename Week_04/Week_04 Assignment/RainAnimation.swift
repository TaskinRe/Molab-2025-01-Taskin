//
//  RainAnimation.swift
//  Week_06 Assignmnet
//
//  Created by Rehnuma Taskin on 25/02/2025.
//


import SwiftUI

struct RainAnimation: View {
    @State private var raindrops = Array(repeating: CGFloat.random(in: -100...100), count: 100)

    var body: some View {
        ZStack {
            ForEach(0..<raindrops.count, id: \.self) { i in
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 2, height: CGFloat.random(in: 10...20))
                    .offset(x: raindrops[i], y: -UIScreen.main.bounds.height / 2)
                    .animation(
                        Animation.linear(duration: Double.random(in: 1.5...3))
                            .repeatForever()
                            .delay(Double(i) * 0.02),
                        value: raindrops[i]
                    )
            }
        }
        .background(Color.black.opacity(0.5))
        .ignoresSafeArea()
        .onAppear {
            raindrops = raindrops.map { _ in CGFloat.random(in: -200...200) }
        }
    }
}
