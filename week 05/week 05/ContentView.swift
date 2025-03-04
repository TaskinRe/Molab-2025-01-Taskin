import SwiftUI

struct ContentView: View {
    @AppStorage("username") private var username: String = ""
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("selectedColor") private var selectedColor: String = "blue"
    
    @State private var showWelcome = false // Controls animation for greeting
    @State private var progress: CGFloat = 0.0 // Tracks progress of text input
    let colors: [String: Color] = ["blue": .blue, "green": .green, "purple": .purple]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Animated Welcome Message
                if showWelcome {
                    Text("Welcome, \(username.isEmpty ? "Guest" : username)!")
                        .font(.title)
                        .transition(.opacity)
                        .padding()
                }
                
                TextField("Enter your name", text: $username, onEditingChanged: { _ in
                    withAnimation { progress = CGFloat(username.count) / 10.0 } // Updates progress bar
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                // Progress Bar for Username Input
                ProgressView(value: progress)
                    .padding()
                    .progressViewStyle(LinearProgressViewStyle(tint: colors[selectedColor] ?? .blue))
                
                HStack {
                    Button("Reset Name") {
                        username = ""
                        withAnimation { progress = 0.0 }
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .simultaneousGesture(TapGesture().onEnded {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred() // Haptic Feedback
                    })
                    
                    Button("Surprise Me") {
                        let randomNames = ["Nova", "Echo", "Zara", "Kai", "Orion"]
                        username = randomNames.randomElement() ?? "Guest"
                        withAnimation { progress = CGFloat(username.count) / 10.0 }
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .simultaneousGesture(TapGesture().onEnded {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred() // Haptic Feedback
                    })
                }
                
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding()
                
                Picker("Select Theme Color", selection: $selectedColor) {
                    Text("Blue").tag("blue")
                    Text("Green").tag("green")
                    Text("Purple").tag("purple")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                NavigationLink(destination: DetailView(username: username)) {
                    Text("Go to Detail View")
                        .padding()
                        .background(colors[selectedColor] ?? .blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(colors[selectedColor]?.opacity(0.2) ?? Color.gray.opacity(0.2)) // Dynamic Background
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .navigationTitle("Home")
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) { showWelcome = true }
            }
        }
    }
}

// ✅ SwiftUI Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
