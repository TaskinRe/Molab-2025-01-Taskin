import SwiftUI

struct ContentView: View {
    @StateObject var dataController = DataController()
    @State private var isShowingRecordSheet = false

    var body: some View {
        ZStack {
            // Use our animated gradient background for a dynamic look.
            AnimatedGradientBackground()
                .ignoresSafeArea()
            
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
            // Optional: Set a custom global font for the entire view hierarchy.
            .font(.custom("HelveticaNeue", size: 16))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
