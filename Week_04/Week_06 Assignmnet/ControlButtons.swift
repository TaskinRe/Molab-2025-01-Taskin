//
//  ControlButtons.swift
//  Week_06 Assignmnet
//
//  Created by Rehnuma Taskin on 25/02/2025.
//


import SwiftUI

struct ControlButtons: View {
    let isRunning: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onReset: () -> Void

    var body: some View {
        HStack(spacing: 30) {
            
            // 🔄 Reset Button
            Button(action: onReset) {
                Image(systemName: "gobackward")
                    .buttonStyle()
            }

            // ▶️ / ⏸️ Toggle Button
            Button(action: isRunning ? onPause : onStart) {
                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                    .buttonStyle()
                    .scaleEffect(isRunning ? 1 : 1.2)
            }
        }
    }
}

extension View {
    func buttonStyle() -> some View {
        self
            .font(.title)
            .padding(20)
            .background(Circle().fill(.teal))
            .foregroundColor(.white)
            .shadow(radius: 10)
    }
}
