import SwiftUI

struct DayDetailView: View {
    let date: Date
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var photoManager: PhotoManager
    @EnvironmentObject var projectManager: ProjectManager

    @State private var selectedPhoto: Photo?
    @State private var selectedPhotosForExport: Set<UUID> = []
    @State private var isSelectionMode = false
    @State private var showingExportConfirmation = false
    @State private var showingDeleteConfirmation = false
    @State private var exportError: String?
    @State private var showingExportError = false

    var photos: [Photo] {
        photoManager.photos(forDate: date)
    }

    var projectsOnDate: [Project] {
        projectManager.projectsWithPhotos(onDate: date, photos: photoManager.photos)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Date header
                    VStack(spacing: 4) {
                        Text(date.formattedDayName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.appTextPrimary)
                        Text(date.formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.appTextSecondary)
                    }
                    .padding(.top)

                    // Stats
                    HStack(spacing: 24) {
                        StatBadge(
                            icon: "photo.fill",
                            value: "\(photos.count)",
                            label: "Photos"
                        )

                        StatBadge(
                            icon: "folder.fill",
                            value: "\(projectsOnDate.count)",
                            label: "Projects"
                        )
                    }

                    if photos.isEmpty {
                        EmptyDateView(date: date)
                            .padding(.top, 20)
                    } else {
                        // Selection mode toggle
                        HStack {
                            Text("Photos")
                                .font(.headline)
                                .foregroundColor(.appTextPrimary)

                            Spacer()

                            Button {
                                isSelectionMode.toggle()
                                if !isSelectionMode {
                                    selectedPhotosForExport.removeAll()
                                }
                            } label: {
                                Text(isSelectionMode ? "Cancel" : "Select")
                                    .font(.subheadline)
                                    .foregroundColor(.appPrimary)
                            }
                        }
                        .padding(.horizontal)

                        // Photo grid
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 4),
                                GridItem(.flexible(), spacing: 4),
                                GridItem(.flexible(), spacing: 4)
                            ],
                            spacing: 4
                        ) {
                            ForEach(photos) { photo in
                                SelectablePhotoCell(
                                    photo: photo,
                                    isSelected: selectedPhotosForExport.contains(photo.id),
                                    isSelectionMode: isSelectionMode
                                ) {
                                    if isSelectionMode {
                                        toggleSelection(photo)
                                    } else {
                                        selectedPhoto = photo
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Selection actions
                        if isSelectionMode && !selectedPhotosForExport.isEmpty {
                            SelectionActionsBar(
                                selectedCount: selectedPhotosForExport.count,
                                onExport: { showingExportConfirmation = true },
                                onDelete: { showingDeleteConfirmation = true }
                            )
                        }
                    }
                }
                .padding(.bottom, isSelectionMode ? 100 : 20)
            }
            .background(Color.appBackground)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedPhoto) { photo in
                PhotoDetailView(photo: photo)
            }
            .alert("Export Photos", isPresented: $showingExportConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Export") {
                    exportSelectedPhotos()
                }
            } message: {
                Text("Save \(selectedPhotosForExport.count) photo(s) to your Photo Library?")
            }
            .alert("Delete Photos", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deleteSelectedPhotos()
                }
            } message: {
                Text("Are you sure you want to delete \(selectedPhotosForExport.count) photo(s)? This cannot be undone.")
            }
            .alert("Export Error", isPresented: $showingExportError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(exportError ?? "Failed to export photos")
            }
        }
    }

    private func toggleSelection(_ photo: Photo) {
        if selectedPhotosForExport.contains(photo.id) {
            selectedPhotosForExport.remove(photo.id)
        } else {
            selectedPhotosForExport.insert(photo.id)
        }
    }

    private func exportSelectedPhotos() {
        let photosToExport = photos.filter { selectedPhotosForExport.contains($0.id) }
        let images = photosToExport.compactMap { photoManager.loadImage(for: $0) }

        Task {
            do {
                try await PhotoLibraryService.shared.saveMultipleToPhotoLibrary(images: images)
                selectedPhotosForExport.removeAll()
                isSelectionMode = false
            } catch {
                exportError = error.localizedDescription
                showingExportError = true
            }
        }
    }

    private func deleteSelectedPhotos() {
        let photosToDelete = photos.filter { selectedPhotosForExport.contains($0.id) }
        photoManager.deletePhotos(photosToDelete)
        selectedPhotosForExport.removeAll()
        isSelectionMode = false
    }
}

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(.appPrimary)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.appTextPrimary)
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.appTextSecondary)
        }
        .frame(minWidth: 80)
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(12)
    }
}

struct SelectablePhotoCell: View {
    let photo: Photo
    let isSelected: Bool
    let isSelectionMode: Bool
    var onTap: () -> Void

    @EnvironmentObject var photoManager: PhotoManager

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                PhotoThumbnailView(
                    photo: photo,
                    size: geometry.size.width,
                    cornerRadius: 4
                )
                .onTapGesture(perform: onTap)

                if isSelectionMode {
                    Circle()
                        .fill(isSelected ? Color.appPrimary : Color.white.opacity(0.8))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: isSelected ? "checkmark" : "")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .overlay(
                            Circle()
                                .stroke(isSelected ? Color.appPrimary : Color.gray, lineWidth: 2)
                        )
                        .padding(6)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct SelectionActionsBar: View {
    let selectedCount: Int
    var onExport: () -> Void
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Button(action: onExport) {
                VStack(spacing: 4) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title3)
                    Text("Export")
                        .font(.caption)
                }
                .foregroundColor(.appPrimary)
            }

            Spacer()

            Text("\(selectedCount) selected")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.appTextPrimary)

            Spacer()

            Button(action: onDelete) {
                VStack(spacing: 4) {
                    Image(systemName: "trash")
                        .font(.title3)
                    Text("Delete")
                        .font(.caption)
                }
                .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -2)
        .padding(.horizontal)
    }
}

#Preview {
    DayDetailView(date: Date())
        .environmentObject(PhotoManager())
        .environmentObject(ProjectManager())
}
