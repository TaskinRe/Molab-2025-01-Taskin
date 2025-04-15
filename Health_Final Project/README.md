## Overview

Health Final Project is an application designed to assist users in managing their health records and voice-based inputs. The project allows users to record their voice, transcribe speech into text, manage medical documents, generate QR code profiles for health information, and receive personalized health recommendations. The application is built with a focus on a modern and professional user interface that features animated backgrounds, custom button styles, and smooth transitions.

## Features

Voice Recording and Transcription
Record audio using the device microphone and automatically convert the speech into text. The system saves both the audio file and its transcription along with a timestamp.
Medical Records Management
Upload, view, and manage various medical documents securely in the application.
QR Code Health Profile
Generate and display a QR code that encapsulates essential health information for sharing.
Guided Health Recommendations
Provide personalized health recommendations based on user input and recorded data.
Animated and Dynamic User Interface
Enjoy a visually appealing experience with animated gradient backgrounds, custom button styles, and seamless navigation between different sections.
Technologies Used

SwiftUI for building the user interface and managing UI state.
AVFoundation for handling audio recording and playback.
Speech framework for converting recorded audio to text.
CoreImage for generating QR codes.
UserNotifications for scheduling reminders and alerts.
Standard iOS frameworks for file and data management.
Current Work

Developed a modular voice recording system that captures audio, transcribes speech using the Speech framework, and stores recordings.
Implemented a document management module for uploading and viewing medical records.
Created visually appealing UI components including an animated gradient background and refined button styles.
Integrated a QR code module that generates health profiles for easy sharing.
Built a guidance module that provides personalized health recommendations based on user-entered information.
Next Steps

Enhance the recording and transcription module with improved error handling and user feedback.
Extend language support for speech recognition and transcription.
Strengthen security and privacy features in the document management module.
Expand the guidance module to incorporate additional health metrics and more detailed recommendations.
Continuously refine the user interface and user experience based on feedback and testing on various devices.
Installation and Usage

Clone the repository.
Open the project in Xcode.
Ensure that the Info.plist contains the necessary permission keys:
NSMicrophoneUsageDescription: "This app needs access to your microphone to record audio."
NSSpeechRecognitionUsageDescription: "This app uses speech recognition to transcribe your recorded audio."
Build and run the project on a real device (voice recording and speech recognition are best tested on hardware).
Follow the on-screen instructions to record audio, manage health documents, generate QR codes, and access personalized guidance.
Project Structure

The project is organized into several groups for clarity:

Health Final Project
├── App Files
│   ├── Health.swift                  // Application entry point
│   ├── ContentView.swift             // Main view with a TabView for navigation
│   ├── MedicalTranscriptionView.swift
│   ├── MedicalRecordManagementView.swift
│   ├── QRCodeHealthProfileView.swift
│   └── AIPoweredGuidanceView.swift   // Provides guided health recommendations
├── VoiceRecording                    // Contains voice recording related modules
│   ├── Recording.swift               // Model for each voice recording
│   ├── DataController.swift          // Handles saving and loading recordings
│   ├── Recorder.swift                // Manages audio recording and transcription
│   ├── NewRecordingView.swift        // UI for starting and saving a recording session
│   ├── PlaybackView.swift            // UI for playing back saved recordings
│   └── RecordingCellView.swift       // Custom list cell for displaying a recording
└── Utilities                         // Utility and supporting components
    ├── AnimatedGradientBackground.swift   // Animated gradient background view
    ├── PrimaryButtonStyle.swift           // Custom button style
    └── Extensions.swift                     // Contains extensions such as URL.documentsDirectory
Contributions

Contributions are welcome. Please submit issues or pull requests if you have suggestions or improvements. Your input will help make this project even better.

License

This project is licensed under the MIT License.

Contact

For questions or further details, please open a GitHub issue or contact the project maintainer through the GitHub repository.




ChatGPT can make mistakes. Check important info.
