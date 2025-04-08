//
//  AIPoweredGuidanceView.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 08/04/2025.
//


import SwiftUI
import UserNotifications

struct AIPoweredGuidanceView: View {
    @State private var symptomInput: String = ""
    @State private var aiResponse: String = "Enter symptoms and get personalized recommendations."
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("SecondaryColor"), Color("AccentColor")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("AI-Powered Guidance")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)
                
                TextField("Enter your symptoms...", text: $symptomInput)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                Button("Get Guidance") {
                    aiResponse = getAIGuidance(for: symptomInput)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
                
                ScrollView {
                    Text(aiResponse)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                }
                
                Button("Set Medication Reminder") {
                    scheduleMedicationReminder()
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
    
    func getAIGuidance(for symptoms: String) -> String {
        return "Based on your symptoms: \(symptoms), please rest and stay hydrated. If symptoms persist, consult your doctor."
    }
    
    func scheduleMedicationReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Time to take your medication!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "MedicationReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling reminder: \(error.localizedDescription)")
            }
        }
    }
}

struct AIPoweredGuidanceView_Previews: PreviewProvider {
    static var previews: some View {
        AIPoweredGuidanceView()
    }
}
