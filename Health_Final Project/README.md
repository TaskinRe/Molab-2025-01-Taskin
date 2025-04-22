# Health Final Project

## Overview

Health Final Project is an application designed to assist users in managing their health records and voice inputs. The project allows users to record their voice, transcribe speech into text, manage medical documents, generate QR code profiles with essential health information, and receive personalized health recommendations. The application is built using modern iOS technologies and features an animated, dynamic user interface with smooth interactions and professional aesthetics.

## Features

- **Voice Recording and Transcription**  
  Record audio using the device microphone and automatically convert speech into text. Both the audio file and its transcription are stored with a timestamp.

- **Medical Records Management**  
  Securely upload, view, and manage various medical documents directly within the app.

- **QR Code Health Profile**  
  Generate and share a QR code that encapsulates a summary of essential health information.

- **Guided Health Recommendations**  
  Receive personalized health recommendations based on collected data and user input.

- **Animated, Dynamic UI**  
  Enjoy a visually appealing experience with animated gradient backgrounds, custom button styles, and seamless navigation between sections.

## Technologies Used

- **SwiftUI** for building the user interface and managing UI state.
- **AVFoundation** for handling audio recording and playback.
- **Speech Framework** for converting recorded audio to text.
- **CoreImage** for generating QR codes.
- **UserNotifications** for scheduling reminders and alerts.
- Standard iOS frameworks for file and data management.

## Current Work

- Developed a modular voice recording system that captures audio and transcribes speech using the Speech framework.
- Implemented a document management module for uploading and viewing medical records.
- Created a visually appealing animated gradient background and refined custom button styles.
- Integrated a QR code module for generating shareable health profiles.
- Built a guided recommendation module that provides personalized health recommendations based on user input.

## Next Steps

- Enhance the voice recording and transcription module with improved error handling and user feedback.
- Extend language support for transcription to accommodate multiple languages.
- Strengthen security measures in the document management module to improve data privacy.
- Expand the recommendations module to include additional health metrics and more detailed advice.
- Continuously refine and polish the user interface based on user feedback and testing.

## Installation and Usage

1. **Clone the Repository:**  
   `git clone <repository-url>`

2. **Open in Xcode:**  
   Open the project in Xcode.

3. **Update Info.plist:**  
   Ensure that the following permission keys are added:
   - `NSMicrophoneUsageDescription`: "This app needs access to your microphone to record audio."
   - `NSSpeechRecognitionUsageDescription`: "This app uses speech recognition to transcribe your recorded audio."

4. **Build and Run:**  
   Build and run the project on a real device (voice recording and transcription are best tested on hardware).

5. **Follow On-Screen Instructions:**  
   Use the interface to record voice entries, manage health documents, generate QR code profiles, and access guided recommendations.
6. **Resources for integrating API:**

    heathkit samples

  - https://github.com/molab-itp/content-2025-01/blob/main/weeks/08_video.md#wwdc-sample-code

  - https://developer.apple.com/documentation/healthkit/build-a-workout-app-for-apple-watch

  - https://developer.apple.com/documentation/healthkit/visualizing-healthkit-state-of-mind-in-visionos

  - https://developer.apple.com/documentation/healthkit/creating-a-mobility-health-app

  - https://yaacoub.github.io/articles/swift-tip/retrieve-daily-step-count-from-healthkit-in-swift/



## Project Structure

The project is organized into several groups to maintain clarity and modularity:

