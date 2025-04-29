//  ContentView.swift
//  Health_FinalProject
//
//  Created by Rehnuma Taskin on 08/04/2025.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    // — your existing state
    @StateObject var dataController     = DataController()
    @State private var isShowingRecordSheet = false

    // — HealthKit & dashboard state
    @StateObject private var hm           = HealthManager()
    @State private var selectedMetric: MetricType?
    @State private var goals: [MetricType: Double] = {
        var d = [MetricType: Double]()
        MetricType.allCases.forEach { d[$0] = $0.defaultGoal() }
        return d
    }()

    private let columns = [ GridItem(.flexible()), GridItem(.flexible()) ]

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // — Interactive Health rings
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: columns, spacing: 16) {
                        ForEach(MetricType.allCases) { m in
                            MetricRingView(
                                type: m,
                                value: value(for: m),
                                goal: goals[m]!
                            )
                            .onTapGesture { selectedMetric = m }
                        }
                    }
                    .padding(.horizontal).padding(.top, 32)
                }
                .frame(height: 160)

                Divider().background(Color.surface).padding(.vertical, 8)

                // — your existing TabView
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
                .accentColor(.accent)
                .font(.custom("HelveticaNeue", size: 16))
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                    // daily summary at 7 PM
                    NotificationManager.shared.scheduleDailyReminder(
                        id: "dailyHealthCheck",
                        title: "How are you doing today?",
                        body: "Check your steps, calories, heart-rate & sleep.",
                        hour: 19, minute: 0
                    )
                    // wind-down sleep at 10 PM
                    NotificationManager.shared.scheduleDailyReminder(
                        id: "sleepReminder",
                        title: "Wind Down 🛌",
                        body: "Aim for 7–8 hours sleep tonight.",
                        hour: 22, minute: 0
                    )
                    // hourly water 9AM–9PM
                    for h in 9...21 {
                        NotificationManager.shared.scheduleDailyReminder(
                            id: "water_\(h)",
                            title: "Hydrate 💧",
                            body: "Take a glass of water.",
                            hour: h, minute: 0
                        )
                    }
                    // meds
                    NotificationManager.shared.scheduleDailyReminder(
                        id: "medMorning",
                        title: "Medicine 💊",
                        body: "Time for your morning dose.",
                        hour: 8, minute: 0
                    )
                    NotificationManager.shared.scheduleDailyReminder(
                        id: "medAfternoon",
                        title: "Medicine 💊",
                        body: "Time for your afternoon dose.",
                        hour: 13, minute: 0
                    )
                    NotificationManager.shared.scheduleDailyReminder(
                        id: "medEvening",
                        title: "Medicine 💊",
                        body: "Time for your evening dose.",
                        hour: 20, minute: 0
                    )
                }
            }
        }
        .sheet(item: $selectedMetric) { m in
            MetricDetailView(
                goal: Binding(
                    get: { goals[m]! },
                    set: { goals[m] = $0 }
                ),
                type: m,
                hm: hm
            )
        }
    }

    private func value(for m: MetricType) -> Double {
        switch m {
        case .steps:     return hm.steps
        case .calories:  return hm.calories
        case .heartRate: return hm.heartRate
        case .sleep:     return hm.sleepHours
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
