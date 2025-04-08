//
//  ContentView.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 06/04/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                startPoint: .top,
                endPoint: .bottom)
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
            }
            .accentColor(.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
