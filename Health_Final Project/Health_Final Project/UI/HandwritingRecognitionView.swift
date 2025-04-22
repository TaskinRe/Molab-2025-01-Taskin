//
//  HandwritingRecognitionView.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 15/04/2025.
//


import SwiftUI
import Vision

struct HandwritingRecognitionView: View {
    @State private var recognizedText = "Handwritten text will appear here..."
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        ZStack {
            // A simple gradient background defined in code
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.2, blue: 0.5),
                                                       Color(red: 0.2, green: 0.4, blue: 0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    Text(recognizedText)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.black.opacity(0.3))
                .cornerRadius(8)
                .padding()

                Button("Select Image") {
                    showingImagePicker = true
                }
                .padding()
                .background(Color(red: 0.0, green: 0.5, blue: 1.0))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: recognizeTextFromImage) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func recognizeTextFromImage() {
        guard let uiImage = inputImage else { return }
        guard let cgImage = uiImage.cgImage else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                DispatchQueue.main.async {
                    recognizedText = "Error recognizing text: \(error.localizedDescription)"
                }
                return
            }
            
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let text = observations.compactMap { observation in
                    return observation.topCandidates(1).first?.string
                }.joined(separator: "\n")
                
                DispatchQueue.main.async {
                    recognizedText = text
                }
            }
        }
        request.recognitionLevel = .accurate
        
        do {
            try requestHandler.perform([request])
        } catch {
            recognizedText = "Failed to perform text recognition: \(error.localizedDescription)"
        }
    }
}

struct HandwritingRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        HandwritingRecognitionView()
    }
}
