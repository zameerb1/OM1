import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var photoManager: PhotoManager

    @State private var showingResetAlert = false
    @State private var showingDeleteAllAlert = false

    var body: some View {
        NavigationStack {
            List {
                // Photo Settings
                Section {
                    Toggle("Auto-save to Photos", isOn: $settingsManager.autoSaveToPhotos)

                    Picker("Default Grid Columns", selection: $settingsManager.gridViewColumns) {
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                    }
                } header: {
                    Text("Photo Settings")
                }

                // Calendar Settings
                Section {
                    Toggle("Show Past Dates", isOn: $settingsManager.showPastDates)
                    Toggle("Default to Future Date", isOn: $settingsManager.defaultToFutureDate)
                } header: {
                    Text("Calendar Settings")
                }

                // Appearance
                Section {
                    Toggle("Dark Mode", isOn: $settingsManager.isDarkMode)
                } header: {
                    Text("Appearance")
                }

                // Data Management
                Section {
                    HStack {
                        Text("Photos")
                        Spacer()
                        Text("\(photoManager.photos.count)")
                            .foregroundColor(.appTextSecondary)
                    }

                    HStack {
                        Text("Projects")
                        Spacer()
                        Text("\(projectManager.projects.count)")
                            .foregroundColor(.appTextSecondary)
                    }

                    Button {
                        exportAllPhotos()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export All to Photos")
                        }
                    }
                    .disabled(photoManager.photos.isEmpty)

                    Button(role: .destructive) {
                        showingDeleteAllAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete All Data")
                        }
                    }
                } header: {
                    Text("Data Management")
                }

                // Reset
                Section {
                    Button {
                        showingResetAlert = true
                    } label: {
                        Text("Reset Settings to Default")
                            .foregroundColor(.appPrimary)
                    }
                }

                // About
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.appTextSecondary)
                    }
                } header: {
                    Text("About")
                } footer: {
                    Text("Photo Calendar helps you organize photos by future dates for projects and jobs.")
                        .font(.caption)
                }
            }
            .navigationTitle("Settings")
            .alert("Reset Settings", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    settingsManager.resetSettings()
                }
            } message: {
                Text("Are you sure you want to reset all settings to their default values?")
            }
            .alert("Delete All Data", isPresented: $showingDeleteAllAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete All", role: .destructive) {
                    deleteAllData()
                }
            } message: {
                Text("This will permanently delete all photos and projects. This action cannot be undone.")
            }
        }
    }

    private func exportAllPhotos() {
        let images = photoManager.photos.compactMap { photoManager.loadImage(for: $0) }

        Task {
            try? await PhotoLibraryService.shared.saveMultipleToPhotoLibrary(images: images)
        }
    }

    private func deleteAllData() {
        // Delete all photos
        for photo in photoManager.photos {
            photoManager.deletePhoto(photo)
        }

        // Delete all projects
        for project in projectManager.projects {
            projectManager.deleteProject(project)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
        .environmentObject(ProjectManager())
        .environmentObject(PhotoManager())
}
