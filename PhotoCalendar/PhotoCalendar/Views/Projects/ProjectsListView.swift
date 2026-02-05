import SwiftUI

struct ProjectsListView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var photoManager: PhotoManager

    @State private var showCreateProject = false
    @State private var selectedProject: Project?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if projectManager.projects.isEmpty {
                        EmptyProjectsView {
                            showCreateProject = true
                        }
                    } else {
                        // Stats section
                        HStack(spacing: 16) {
                            ProjectStatCard(
                                icon: "folder.fill",
                                value: "\(projectManager.projects.count)",
                                label: "Projects",
                                color: .appPrimary
                            )

                            ProjectStatCard(
                                icon: "photo.fill",
                                value: "\(photoManager.photos.count)",
                                label: "Total Photos",
                                color: .projectGreen
                            )
                        }
                        .padding(.horizontal)

                        // Projects list
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("All Projects")
                                    .font(.headline)
                                    .foregroundColor(.appTextPrimary)

                                Spacer()

                                Button {
                                    showCreateProject = true
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(.appPrimary)
                                }
                            }
                            .padding(.horizontal)

                            ForEach(projectManager.sortedProjects) { project in
                                NavigationLink {
                                    ProjectDetailView(project: project)
                                } label: {
                                    ProjectCardView(
                                        project: project,
                                        photoCount: photoManager.photos(forProject: project.id).count
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color.appBackground)
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateProject = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateProject) {
                CreateProjectView()
            }
        }
    }
}

struct ProjectStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.appTextPrimary)

            Text(label)
                .font(.caption)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(16)
    }
}

struct EmptyProjectsView: View {
    var onCreate: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "folder.badge.plus")
                .font(.system(size: 64))
                .foregroundColor(.appTextSecondary.opacity(0.5))

            VStack(spacing: 8) {
                Text("No Projects Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.appTextPrimary)

                Text("Create a project to organize your photos by job or task")
                    .font(.body)
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Button(action: onCreate) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Project")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.appPrimary)
                .cornerRadius(12)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    ProjectsListView()
        .environmentObject(ProjectManager())
        .environmentObject(PhotoManager())
}
