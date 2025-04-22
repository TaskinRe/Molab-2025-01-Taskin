import SwiftUI

struct ContentView: View {
    @StateObject var dataController = DataController()
    @State private var isShowingRecordSheet = false

    let healthManager = HealthManager()
    @State private var stepCount: Double = 0.0
    @State private var showLowStepsPrompt = false
    @State private var showRewardScreen = false

    var body: some View {
        ZStack {
            // Background
            AnimatedGradientBackground()
                .ignoresSafeArea()

            VStack {
                // Step count display
                Text("🦶 Steps Today: \(Int(stepCount))")
                    .font(.headline)
                    .padding(10)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(12)
                    .padding(.top, 40)

                Spacer()

                // TabView with your modules
                TabView {
                    MedicalTranscriptionView()
                        .tabItem {
                            Image(systemName: "mic.fill")
                            Text("Transcription")
                        }

                    MedicalRecordManagementView()
                        .tabItem {
                            Image(systemName: "doc.fill")
                            Text("Records")
                        }

                    QRCodeHealthProfileView()
                        .tabItem {
                            Image(systemName: "qrcode")
                            Text("QR Profile")
                        }

                    AIPoweredGuidanceView()
                        .tabItem {
                            Image(systemName: "lightbulb.fill")
                            Text("AI Guidance")
                        }

                    NavigationView {
                        List {
                            ForEach(dataController.filteredRecordings) { recording in
                                RecordingCellView(recording: recording)
                                    .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: dataController.delete)
                        }
                        .listStyle(InsetGroupedListStyle())
                        .navigationTitle("Recordings")
                        .toolbar {
                            Button {
                                isShowingRecordSheet = true
                            } label: {
                                Label("New Recording", systemImage: "plus")
                            }
                        }
                        .searchable(text: $dataController.filter)
                        .sheet(isPresented: $isShowingRecordSheet) {
                            NewRecordingView()
                                .environmentObject(dataController)
                        }
                    }
                    .tabItem {
                        Image(systemName: "waveform")
                        Text("Recordings")
                    }
                }
                .accentColor(Color.primaryColor)
                .font(.custom("HelveticaNeue", size: 16))
                .onAppear {
                    healthManager.requestAuthorization { success, error in
                        if success {
                            healthManager.fetchSteps { steps in
                                self.stepCount = steps

                                if steps < 2000 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showLowStepsPrompt = true
                                    }
                                }
                            }

//                            healthManager.fetchActiveEnergy { kcal in
//                                if kcal > 500 {
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                        showRewardScreen = true
//                                    }
//                                }
         //                   }
                        }
                    }
                }
            }
        }
        // Low Steps Alert
        .alert(isPresented: $showLowStepsPrompt) {
            Alert(
                title: Text("Time to Move! 🚶‍♀️"),
                message: Text("You’ve walked less than 2,000 steps today. A short walk can boost your mood!"),
                dismissButton: .default(Text("Got it!"))
            )
        }

        // Reward Screen Overlay
        .fullScreenCover(isPresented: $showRewardScreen) {
            VStack(spacing: 20) {
                Text("🎉 Great job!")
                    .font(.largeTitle)
                    .bold()
                Text("You've burned over 500 kcal today! Keep up the amazing work.")
                    .multilineTextAlignment(.center)
                    .padding()

                Button("Dismiss") {
                    showRewardScreen = false
                }
                .padding()
                .background(Color.green.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.6).ignoresSafeArea())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
