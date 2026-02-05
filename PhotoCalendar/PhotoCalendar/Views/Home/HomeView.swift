import SwiftUI

struct HomeView: View {
    @EnvironmentObject var photoManager: PhotoManager
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var calendarManager: CalendarManager

    @State private var showCamera = false
    @State private var showCalendar = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Hero section
                    VStack(spacing: 16) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 60))
                            .foregroundColor(.appPrimary)

                        Text("Photo Calendar")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.appTextPrimary)

                        Text("Capture photos and organize them by future dates and projects")
                            .font(.body)
                            .foregroundColor(.appTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)

                    // Main action buttons
                    VStack(spacing: 16) {
                        MainActionButton(
                            title: "Take Photo",
                            subtitle: "Capture and schedule for a future date",
                            icon: "camera.fill",
                            color: .appPrimary
                        ) {
                            showCamera = true
                        }

                        MainActionButton(
                            title: "View Calendar",
                            subtitle: "Browse photos by date",
                            icon: "calendar",
                            color: .projectGreen
                        ) {
                            showCalendar = true
                        }
                    }
                    .padding(.horizontal)

                    // Quick stats
                    if !photoManager.photos.isEmpty || !projectManager.projects.isEmpty {
                        QuickStatsView()
                    }

                    // Recent activity
                    if !photoManager.photos.isEmpty {
                        RecentActivityView()
                    }

                    Spacer(minLength: 100)
                }
            }
            .background(Color.appBackground)
            .fullScreenCover(isPresented: $showCamera) {
                CameraView()
            }
            .fullScreenCover(isPresented: $showCalendar) {
                NavigationStack {
                    CalendarView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Done") {
                                    showCalendar = false
                                }
                            }
                        }
                }
            }
        }
    }
}

struct MainActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 60, height: 60)

                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.appTextSecondary)
            }
            .padding()
            .background(Color.appCardBackground)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickStatsView: View {
    @EnvironmentObject var photoManager: PhotoManager
    @EnvironmentObject var projectManager: ProjectManager

    var upcomingPhotoCount: Int {
        photoManager.photos.filter { $0.assignedDate.isFuture }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.headline)
                .foregroundColor(.appTextPrimary)
                .padding(.horizontal)

            HStack(spacing: 12) {
                QuickStatCard(
                    icon: "photo.stack",
                    value: "\(photoManager.photos.count)",
                    label: "Total Photos"
                )

                QuickStatCard(
                    icon: "folder.fill",
                    value: "\(projectManager.projects.count)",
                    label: "Projects"
                )

                QuickStatCard(
                    icon: "calendar.badge.clock",
                    value: "\(upcomingPhotoCount)",
                    label: "Upcoming"
                )
            }
            .padding(.horizontal)
        }
    }
}

struct QuickStatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.appPrimary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.appTextPrimary)

            Text(label)
                .font(.caption)
                .foregroundColor(.appTextSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.appCardBackground)
        .cornerRadius(12)
    }
}

struct RecentActivityView: View {
    @EnvironmentObject var photoManager: PhotoManager

    var recentPhotos: [Photo] {
        Array(photoManager.photos.sorted { $0.createdAt > $1.createdAt }.prefix(5))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Photos")
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)

                Spacer()

                Text("\(recentPhotos.count) recent")
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(recentPhotos) { photo in
                        VStack(spacing: 8) {
                            PhotoThumbnailView(photo: photo, size: 80, cornerRadius: 8)

                            Text(photo.assignedDate.formattedShortDate)
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(PhotoManager())
        .environmentObject(ProjectManager())
        .environmentObject(CalendarManager())
}
