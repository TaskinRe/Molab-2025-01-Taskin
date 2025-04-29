//  MetricRingView.swift
//  Health_FinalProject
//
//  Created by Rehnuma Taskin on 29/04/2025.
//

import SwiftUI

struct MetricRingView: View {
    let type: MetricType
    let value: Double
    let goal: Double
    @Namespace private var anim

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.surface, lineWidth: 12)

            Circle()
                .trim(from: 0, to: CGFloat(min(value/goal, 1.0)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [.accent, .accent.opacity(0.5)]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: value/goal)

            VStack(spacing: 4) {
                Image(systemName: type.icon)
                    .foregroundColor(.accent)
                    .font(.title2)
                Text(displayText)
                    .font(.headline).bold()
                    .foregroundColor(.textPrimary)
                Text(type.label)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .matchedGeometryEffect(id: type.rawValue, in: anim)
        }
        .frame(width: 120, height: 120)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(4)
    }

    private var displayText: String {
        switch type {
        case .steps:     return "\(Int(value))"
        case .calories:  return "\(Int(value)) kcal"
        case .heartRate: return "\(Int(value)) bpm"
        case .sleep:     return String(format: "%.1f h", value)
        }
    }
}
