import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var calendarManager: CalendarManager
    @EnvironmentObject var photoManager: PhotoManager
    @EnvironmentObject var projectManager: ProjectManager

    @State private var showingDayDetail = false
    @State private var selectedPhoto: Photo?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Calendar Grid
                    CalendarGridView { date in
                        showingDayDetail = true
                    }
                    .padding(.top)

                    // Today button
                    if !calendarManager.selectedDate.isToday {
                        Button {
                            calendarManager.goToToday()
                        } label: {
                            Label("Go to Today", systemImage: "calendar.badge.clock")
                                .font(.subheadline)
                                .foregroundColor(.appPrimary)
                        }
                    }

                    // Selected date info
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(calendarManager.selectedDayName)
                                    .font(.headline)
                                    .foregroundColor(.appTextPrimary)
                                Text(calendarManager.selectedDateFormatted)
                                    .font(.subheadline)
                                    .foregroundColor(.appTextSecondary)
                            }

                            Spacer()

                            let photoCount = photoManager.photoCount(forDate: calendarManager.selectedDate)
                            if photoCount > 0 {
                                Text("\(photoCount) photo\(photoCount == 1 ? "" : "s")")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.appPrimary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.appPrimary.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)

                        // Photos for selected date
                        let photos = photoManager.photos(forDate: calendarManager.selectedDate)

                        if photos.isEmpty {
                            EmptyDateView(date: calendarManager.selectedDate)
                        } else {
                            // Group by project
                            let groupedPhotos = Dictionary(grouping: photos) { $0.projectId }

                            ForEach(Array(groupedPhotos.keys), id: \.self) { projectId in
                                if let projectPhotos = groupedPhotos[projectId] {
                                    PhotoGroupSection(
                                        projectId: projectId,
                                        photos: projectPhotos,
                                        onPhotoTap: { photo in
                                            selectedPhoto = photo
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Calendar")
            .sheet(isPresented: $showingDayDetail) {
                DayDetailView(date: calendarManager.selectedDate)
            }
            .sheet(item: $selectedPhoto) { photo in
                PhotoDetailView(photo: photo)
            }
        }
    }
}

struct PhotoGroupSection: View {
    let projectId: UUID?
    let photos: [Photo]
    var onPhotoTap: ((Photo) -> Void)?

    @EnvironmentObject var projectManager: ProjectManager

    var project: Project? {
        guard let projectId = projectId else { return nil }
        return projectManager.project(withId: projectId)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack {
                if let project = project {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(project.color.gradient)
                        .frame(width: 20, height: 20)
                    Text(project.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appTextPrimary)
                } else {
                    Image(systemName: "photo.on.rectangle")
                        .foregroundColor(.appTextSecondary)
                    Text("Unassigned")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appTextSecondary)
                }

                Spacer()

                Text("\(photos.count)")
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
            }
            .padding(.horizontal)

            // Photo grid
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(photos) { photo in
                        PhotoThumbnailView(photo: photo, size: 80, cornerRadius: 8)
                            .onTapGesture {
                                onPhotoTap?(photo)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct EmptyDateView: View {
    let date: Date

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundColor(.appTextSecondary.opacity(0.5))

            Text("No photos scheduled")
                .font(.headline)
                .foregroundColor(.appTextSecondary)

            Text(date.isFuture ? "Take a photo and schedule it for this date" : "No photos were scheduled for this date")
                .font(.subheadline)
                .foregroundColor(.appTextSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color.appCardBackground)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview {
    CalendarView()
        .environmentObject(CalendarManager())
        .environmentObject(PhotoManager())
        .environmentObject(ProjectManager())
}
