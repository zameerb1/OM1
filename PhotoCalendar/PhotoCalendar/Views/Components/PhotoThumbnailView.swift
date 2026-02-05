import SwiftUI

struct PhotoThumbnailView: View {
    let photo: Photo
    @EnvironmentObject var photoManager: PhotoManager
    var size: CGFloat = 100
    var cornerRadius: CGFloat = 12

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipped()
                    .cornerRadius(cornerRadius)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: size, height: size)
                    .cornerRadius(cornerRadius)
                    .overlay(
                        ProgressView()
                    )
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let loadedImage = photoManager.loadImage(for: photo)
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }
    }
}

struct PhotoGridView: View {
    let photos: [Photo]
    let columns: Int
    var spacing: CGFloat = 4
    var onPhotoTap: ((Photo) -> Void)?

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
    }

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: spacing) {
            ForEach(photos) { photo in
                GeometryReader { geometry in
                    PhotoThumbnailView(photo: photo, size: geometry.size.width, cornerRadius: 4)
                        .onTapGesture {
                            onPhotoTap?(photo)
                        }
                }
                .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct PhotoDetailView: View {
    let photo: Photo
    @EnvironmentObject var photoManager: PhotoManager
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.dismiss) var dismiss

    @State private var image: UIImage?
    @State private var showingDeleteAlert = false
    @State private var showingExportAlert = false
    @State private var exportError: String?

    var project: Project? {
        guard let projectId = photo.projectId else { return nil }
        return projectManager.project(withId: projectId)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .aspectRatio(4/3, contentMode: .fit)
                            .cornerRadius(12)
                            .overlay(ProgressView())
                            .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        // Date info
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.appPrimary)
                            Text(photo.assignedDate.formattedDate)
                                .font(.headline)
                            Spacer()
                        }

                        // Project info
                        if let project = project {
                            HStack {
                                Image(systemName: "folder.fill")
                                    .foregroundColor(project.color.color)
                                Text(project.name)
                                    .font(.subheadline)
                                Spacer()
                            }
                        }

                        // Notes
                        if !photo.notes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.headline)
                                Text(photo.notes)
                                    .font(.body)
                                    .foregroundColor(.appTextSecondary)
                            }
                        }

                        // Created date
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.appTextSecondary)
                            Text("Taken: \(photo.createdAt.formattedDate)")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 40)

                    // Action buttons
                    VStack(spacing: 12) {
                        Button {
                            exportPhoto()
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.appPrimary)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            Label("Delete Photo", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Photo Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Delete Photo", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    photoManager.deletePhoto(photo)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this photo? This cannot be undone.")
            }
            .alert("Export Error", isPresented: $showingExportAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(exportError ?? "Failed to save photo")
            }
            .onAppear {
                loadImage()
            }
        }
    }

    private func loadImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let loadedImage = photoManager.loadImage(for: photo)
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }
    }

    private func exportPhoto() {
        guard let image = image else { return }

        Task {
            do {
                try await PhotoLibraryService.shared.saveToPhotoLibrary(image: image)
            } catch {
                exportError = error.localizedDescription
                showingExportAlert = true
            }
        }
    }
}

#Preview {
    PhotoThumbnailView(
        photo: Photo(
            imageFileName: "test.jpg",
            assignedDate: Date()
        )
    )
    .environmentObject(PhotoManager())
}
