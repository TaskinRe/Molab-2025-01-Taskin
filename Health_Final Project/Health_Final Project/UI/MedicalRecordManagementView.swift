import SwiftUI
import UniformTypeIdentifiers

struct MedicalRecordManagementView: View {
    @State private var documents: [URL] = []
    @State private var isShowingDocumentPicker = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("PrimaryColor"), Color("SecondaryColor")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                Text("Medical Records")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)
                
                List(documents, id: \.self) { doc in
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.blue)
                        Text(doc.lastPathComponent)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .shadow(radius: 3)
                }
                .listStyle(PlainListStyle())
                
                Button("Upload Document") {
                    isShowingDocumentPicker = true
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding()
            }
        }
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPicker(documents: $documents)
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var documents: [URL]
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf, UTType.image, UTType.plainText], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            // Add encryption/secure upload logic here.
            parent.documents.append(contentsOf: urls)
        }
    }
}

struct MedicalRecordManagementView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalRecordManagementView()
    }
}
