//  MetricDetailView.swift
//  Health_FinalProject
//
//  Created by Rehnuma Taskin on 29/04/2025.
//

import SwiftUI

struct MetricDetailView: View {
    @Binding var goal: Double
    let type: MetricType
    @ObservedObject var hm: HealthManager
    @Environment(\.dismiss) var dismiss

    var value: Double {
        switch type {
        case .steps:     return hm.steps
        case .calories:  return hm.calories
        case .heartRate: return hm.heartRate
        case .sleep:     return hm.sleepHours
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            MetricRingView(type: type, value: value, goal: goal)
                .frame(width: 240, height: 240)

            Text("Adjust your daily goal:")
                .font(.subheadline)
                .foregroundColor(.textSecondary)

            Slider(value: $goal, in: sliderRange, step: sliderStep)
                .padding(.horizontal)
                .accentColor(.accent)

            Text("\(Int(goal)) \(unitLabel)")
                .font(.headline)
                .foregroundColor(.textPrimary)

            Spacer()

            Button("Done") { dismiss() }
                .font(.headline)
                .padding(.horizontal, 40).padding(.vertical, 12)
                .background(Color.accent.opacity(0.2))
                .cornerRadius(10)
        }
        .padding()
        .background(Color.background.ignoresSafeArea())
    }

    private var sliderRange: ClosedRange<Double> {
        switch type {
        case .steps:     return 0...20_000
        case .calories:  return 0...2000
        case .heartRate: return 40...180
        case .sleep:     return 0...12
        }
    }

    private var sliderStep: Double { type == .sleep ? 0.1 : 50 }
    private var unitLabel:  String {
        switch type {
        case .calories: return "kcal"
        case .heartRate:return "bpm"
        case .sleep:    return "h"
        default:        return ""
        }
    }
}
