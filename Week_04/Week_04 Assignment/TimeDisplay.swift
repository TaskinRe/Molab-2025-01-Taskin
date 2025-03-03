//
//  TimeDisplay.swift
//  Week_06 Assignmnet
//
//  Created by Rehnuma Taskin on 25/02/2025.
//


import SwiftUI

struct TimeDisplay: View {
    let timeRemaining: TimeInterval

    var body: some View {
        Text(formattedTime)
            .font(.system(size: 64, weight: .bold, design: .monospaced))
            .foregroundColor(.teal)
            .padding()
    }

    private var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
