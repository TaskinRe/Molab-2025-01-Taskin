//
//  NewRecordingView.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 15/04/2025.
//


import SwiftUI

struct NewRecordingView: View {
    @StateObject private var recorder = Recorder()
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Match your app's theme with a gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                switch recorder.recordingState {
                case .waiting:
                    Button {
                        recorder.requestRecordingPermission()
                    } label: {
                        Label("Start Recording", systemImage: "record.circle")
                            .font(.title)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                case .recording:
                    Button {
                        recorder.stopRecording()
                    } label: {
                        Label("Stop Recording", systemImage: "stop.circle")
                            .font(.title)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                case .transcribing:
                    VStack {
                        Text("Transcribing…")
                            .font(.headline)
                        ProgressView()
                    }
                    
                case .complete(let recording):
                    VStack {
                        ScrollView {
                            Text(recording.transcription)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                        }
                        
                        Button("Save Recording") {
                            dataController.add(recording: recording)
                            dismiss()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                if !recorder.errorMessage.isEmpty {
                    Text(recorder.errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
}

struct NewRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecordingView()
            .environmentObject(DataController())
    }
}
