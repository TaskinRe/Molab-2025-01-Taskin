import SwiftUI

@main
struct MeditationTimerApp: App {
    @StateObject private var meditationSession = MeditationSession()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(meditationSession)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    meditationSession.pause()
                }
        }
    }
}
