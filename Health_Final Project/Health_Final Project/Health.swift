//  HealthFinalProjectApp.swift
//  Health_FinalProject
//
//  Created by Rehnuma Taskin on 08/04/2025.
//

import SwiftUI

@main
struct HealthFinalProjectApp: App {
    init() {
        // ask once at launch
        NotificationManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
