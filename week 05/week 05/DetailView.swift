//
//  DetailView.swift
//  week 05
//
//  Created by Rehnuma Taskin on 04/03/2025.
//


import SwiftUI

struct DetailView: View {
    let username: String // ✅ Receives data from ContentView

    var body: some View {
        VStack {
            Text("Hello, \(username)!")
                .font(.largeTitle)
                .padding()

            NavigationLink(destination: SettingsView()) {
                Text("Go to Settings")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("Detail View")
    }
}
