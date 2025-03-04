import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: MeditationSession

    var body: some View {
        TabView {
            NavigationView {
                MeditationView()
            }
            .tabItem { Label("Meditate", systemImage: "timer") }

            NavigationView {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}
