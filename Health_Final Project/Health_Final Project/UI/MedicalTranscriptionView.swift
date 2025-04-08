//
//  MedicalTranscriptionView.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 08/04/2025.
//


import SwiftUI
import AVFoundation
import Speech

struct MedicalTranscriptionView: View {
    @State private var isRecording = false
    @State private var transcript = "Your transcription will appear here..."
    
    // Speech framework properties
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var audioEngine = AVAudioEngine()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("PrimaryColor"), Color("SecondaryColor")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Medical Transcription")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                ScrollView {
                    Text(transcript)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                }
                .frame(height: 200)
                
                // Record button with pulsating animation
                Button(action: {
                    if isRecording {
                        stopRecording()
                    } else {
                        startRecording()
                    }
                    withAnimation { isRecording.toggle() }
                }) {
                    Circle()
                        .fill(isRecording ? Color.red : Color.green)
                        .frame(width: isRecording ? 80 : 70, height: isRecording ? 80 : 70)
                        .overlay(
                            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .bold))
                        )
                        .scaleEffect(isRecording ? 1.1 : 1.0)
                        .shadow(radius: 10)
                }
                .padding()
                
                Button("Translate Medical Jargon") {
                    transcript = translateJargon(text: transcript)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding()
        }
    }
    
    func startRecording() {
        SFSpeechRecognizer.requestAuthorization { authStatus in }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcript = result.bestTranscription.formattedString
                }
            }
            if error != nil || (result?.isFinal ?? false) {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do { try audioEngine.start() }
        catch { print("Audio Engine error: \(error.localizedDescription)") }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    func translateJargon(text: String) -> String {
        // Replace with real medical jargon translation logic.
        return "Translated: \(text)"
    }
}

struct MedicalTranscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalTranscriptionView()
    }
}
