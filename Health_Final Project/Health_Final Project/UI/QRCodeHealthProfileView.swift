//
//  QRCodeHealthProfileView.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 08/04/2025.
//


import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeHealthProfileView: View {
    @State private var healthData: String = "Name: John Doe\nAllergies: None\nBlood Type: O+\nMedications: Aspirin"
    @State private var qrCodeImage: Image?
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("QR Code Health Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)
                
                if let qrCodeImage = qrCodeImage {
                    qrCodeImage
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .shadow(radius: 10)
                } else {
                    Text("Generating QR Code...")
                        .foregroundColor(.white)
                }
                
                Button("Generate QR Code") {
                    generateQRCode(from: healthData)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Share QR Code") {
                    shareQRCode()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
        }
    }
    
    func generateQRCode(from string: String) {
        let data = Data(string.utf8)
        filter.message = data
        if let outputImage = filter.outputImage,
           let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            qrCodeImage = Image(uiImage: uiImage)
        }
    }
    
    func shareQRCode() {
        guard let qrCodeImage = qrCodeImage else { return }
        let uiImage = qrCodeImage.asUIImage()
        let activityVC = UIActivityViewController(activityItems: [uiImage], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
    }
}

extension Image {
    // Helper to convert Image back to UIImage (for sharing purposes).
    func asUIImage() -> UIImage {
        let data = Data("Name: John Doe\nAllergies: None\nBlood Type: O+\nMedications: Aspirin".utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.message = data
        let context = CIContext()
        if let outputImage = filter.outputImage,
           let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
        return UIImage()
    }
}

struct QRCodeHealthProfileView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeHealthProfileView()
    }
}
