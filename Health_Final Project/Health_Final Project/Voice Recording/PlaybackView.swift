//
//  PlaybackView.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 15/04/2025.
//


import AVFoundation
import SwiftUI

struct PlaybackView: View {
    @State private var player: AVAudioPlayer?
    let recording: Recording

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    Text(recording.transcription)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .shadow(radius: 5)
                        .padding()
                }
                
                Button(action: play) {
                    Label("Play Recording", systemImage: "play.fill")
                        .font(.title2)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding()
            }
        }
        .navigationTitle(recording.date.formatted(date: .abbreviated, time: .shortened))
    }

    func play() {
        do {
            let url = URL.documentsDirectory.appending(path: recording.filename)
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Playback error: \(error.localizedDescription)")
        }
    }
}

struct PlaybackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlaybackView(recording: Recording.example)
        }
    }
}
