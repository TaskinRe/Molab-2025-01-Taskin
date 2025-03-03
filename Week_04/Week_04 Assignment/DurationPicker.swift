//
//  DurationPicker.swift
//  Week_06 Assignmnet
//
//  Created by Rehnuma Taskin on 25/02/2025.
//


import SwiftUI

struct DurationPicker: View {
    @Binding var selectedDuration: TimeInterval

    var body: some View {
        Picker("Duration", selection: $selectedDuration) {
            Text("3 min").tag(300.0)
            Text("5 min").tag(600.0)
            Text("10 min").tag(900.0)
            Text("20 min").tag(1200.0)
        }
        .pickerStyle(.segmented)
        .padding()
    }
}
