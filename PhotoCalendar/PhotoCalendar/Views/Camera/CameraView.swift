import SwiftUI
import UIKit

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var photoManager: PhotoManager
    @EnvironmentObject var projectManager: ProjectManager

    @State private var capturedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showPhotoWorkflow = false

    var body: some View {
        NavigationStack {
            VStack {
                if CameraService.shared.isCameraAvailable {
                    CameraPlaceholderView(
                        onCapture: {
                            showImagePicker = true
                        }
                    )
                } else {
                    NoCameraView()
                }
            }
            .navigationTitle("Take Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $capturedImage, sourceType: .camera)
            }
            .onChange(of: capturedImage) { _, newImage in
                if newImage != nil {
                    showPhotoWorkflow = true
                }
            }
            .fullScreenCover(isPresented: $showPhotoWorkflow) {
                if let image = capturedImage {
                    PhotoWorkflowView(capturedImage: image) {
                        capturedImage = nil
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CameraPlaceholderView: View {
    var onCapture: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "camera.fill")
                .font(.system(size: 80))
                .foregroundColor(.appPrimary)

            Text("Take a Photo")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.appTextPrimary)

            Text("Capture photos and assign them to future dates and projects")
                .font(.body)
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            Button(action: onCapture) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Open Camera")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.appPrimary)
                .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

struct NoCameraView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.system(size: 60))
                .foregroundColor(.appTextSecondary)

            Text("Camera Not Available")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.appTextPrimary)

            Text("This device does not have a camera or camera access is not available.")
                .font(.body)
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    CameraView()
        .environmentObject(PhotoManager())
        .environmentObject(ProjectManager())
}
