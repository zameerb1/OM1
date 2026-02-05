import SwiftUI

struct ProjectDetailView: View {
    let project: Project

    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var photoManager: PhotoManager
    @Environment(\.dismiss) var dismiss

    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    @State private var selectedPhoto: Photo?

    var photos: [Photo] {
        photoManager.photos(forProject: project.id)
    }

    var photosByDate: [(Date, [Photo])] {
        let grouped = Dictionary(grouping: photos) { $0.assignedDate.startOfDay }
        return grouped.sorted { $0.key < $1.key }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Project header
                ProjectHeaderView(project: project)

                // Timeline info
                if project.startDate != nil || project.endDate != nil {
                    ProjectTimelineView(project: project)
                }

                // Notes
                if !project.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)
                        Text(project.notes)
                            .font(.body)
                            .foregroundColor(.appTextSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.appCardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // Photos section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Photos")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)

                        Spacer()

                        Text("\(photos.count) total")
                            .font(.subheadline)
                            .foregroundColor(.appTextSecondary)
                    }
                    .padding(.horizontal)

                    if photos.isEmpty {
                        EmptyProjectPhotosView()
                    } else {
                        // Photos grouped by date
                        ForEach(photosByDate, id: \.0) { date, datePhotos in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(date.formattedDate)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.appTextSecondary)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(datePhotos) { photo in
                                            PhotoThumbnailView(photo: photo, size: 100, cornerRadius: 8)
                                                .onTapGesture {
                                                    selectedPhoto = photo
                                                }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .padding(.vertical)
        }
        .background(Color.appBackground)
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        isEditing = true
                    } label: {
                        Label("Edit Project", systemImage: "pencil")
                    }

                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete Project", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditProjectView(project: project)
        }
        .sheet(item: $selectedPhoto) { photo in
            PhotoDetailView(photo: photo)
        }
        .alert("Delete Project", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                projectManager.deleteProject(project)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this project? Photos will not be deleted but will be unassigned.")
        }
    }
}

struct ProjectHeaderView: View {
    let project: Project

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(project.color.gradient)
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: project.color.icon)
                        .font(.title)
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(project.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.appTextPrimary)

                Text("Created \(project.createdAt.formattedDate)")
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct ProjectTimelineView: View {
    let project: Project

    var body: some View {
        HStack(spacing: 20) {
            if let startDate = project.startDate {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Start Date")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                    Text(startDate.formattedShortDate)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.appTextPrimary)
                }
            }

            if project.startDate != nil && project.endDate != nil {
                Image(systemName: "arrow.right")
                    .foregroundColor(.appTextSecondary)
            }

            if let endDate = project.endDate {
                VStack(alignment: .leading, spacing: 4) {
                    Text("End Date")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                    Text(endDate.formattedShortDate)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.appTextPrimary)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct EmptyProjectPhotosView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 40))
                .foregroundColor(.appTextSecondary.opacity(0.5))

            Text("No photos yet")
                .font(.headline)
                .foregroundColor(.appTextSecondary)

            Text("Take a photo and assign it to this project")
                .font(.caption)
                .foregroundColor(.appTextSecondary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        ProjectDetailView(project: Project(name: "Kitchen Renovation", color: .blue))
    }
    .environmentObject(ProjectManager())
    .environmentObject(PhotoManager())
}
