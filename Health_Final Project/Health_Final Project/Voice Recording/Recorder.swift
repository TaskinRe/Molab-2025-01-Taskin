//
//  Recorder.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 15/04/2025.
//


import AVFoundation
import Speech
import SwiftUI

class Recorder: ObservableObject {
    enum RecordingState {
        case waiting, recording, transcribing, complete(Recording)
    }
    
    @Published var recordingState = RecordingState.waiting
    @Published var errorMessage = ""
    
    private var recordingSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder?
    private let temporaryURL = URL.documentsDirectory.appending(path: "recording.m4a")
    
    func requestRecordingPermission() {
        recordingSession.requestRecordPermission { allowed in
            DispatchQueue.main.async {
                if allowed {
                    self.requestTranscribePermission()
                } else {
                    self.errorMessage = "You need to grant microphone permission."
                }
            }
        }
    }
    
    private func requestTranscribePermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.startRecording()
                } else {
                    self.errorMessage = "Speech recognition not authorized."
                }
            }
        }
    }
    
    private func startRecording() {
        let settings = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1
        ]
        
        do {
            try recordingSession.setCategory(.playAndRecord)
            try recordingSession.setActive(true)
            audioRecorder = try AVAudioRecorder(url: temporaryURL, settings: settings)
            audioRecorder?.record()
            recordingState = .recording
        } catch {
            errorMessage = "Failed to configure recording: \(error.localizedDescription)"
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        transcribe()
    }
    
    private func transcribe() {
        recordingState = .transcribing
        
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: temporaryURL)
        request.requiresOnDeviceRecognition = true
        request.shouldReportPartialResults = false
        request.addsPunctuation = true
        request.taskHint = .dictation
        
        recognizer?.recognitionTask(with: request) { result, error in
            guard let result = result else {
                self.errorMessage = error?.localizedDescription ?? "Unknown error"
                return
            }
            
            let id = UUID()
            let filename = "\(id.uuidString).m4a"
            let recording = Recording(id: id, date: .now, filename: filename, transcription: result.bestTranscription.formattedString)
            
            do {
                let newURL = URL.documentsDirectory.appending(path: filename)
                try FileManager.default.moveItem(at: self.temporaryURL, to: newURL)
                DispatchQueue.main.async {
                    self.recordingState = .complete(recording)
                }
            } catch {
                self.errorMessage = "Error saving recording: \(error.localizedDescription)"
                self.recordingState = .waiting
            }
        }
    }
}
