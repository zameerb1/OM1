import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home
        case calendar
        case projects
        case settings
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .calendar:
                    CalendarView()
                case .projects:
                    ProjectsListView()
                case .settings:
                    SettingsView()
                }
            }

            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == .home
            ) {
                selectedTab = .home
            }

            TabBarButton(
                icon: "calendar",
                title: "Calendar",
                isSelected: selectedTab == .calendar
            ) {
                selectedTab = .calendar
            }

            // Center camera button
            CenterCameraButton()

            TabBarButton(
                icon: "folder.fill",
                title: "Projects",
                isSelected: selectedTab == .projects
            ) {
                selectedTab = .projects
            }

            TabBarButton(
                icon: "gearshape.fill",
                title: "Settings",
                isSelected: selectedTab == .settings
            ) {
                selectedTab = .settings
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(
            Color.appCardBackground
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: -4)
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .appPrimary : .appTextSecondary)

                Text(title)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .appPrimary : .appTextSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CenterCameraButton: View {
    @State private var showCamera = false
    @EnvironmentObject var photoManager: PhotoManager
    @EnvironmentObject var projectManager: ProjectManager

    var body: some View {
        Button {
            showCamera = true
        } label: {
            ZStack {
                Circle()
                    .fill(Color.appPrimary)
                    .frame(width: 56, height: 56)
                    .shadow(color: .appPrimary.opacity(0.4), radius: 8, x: 0, y: 4)

                Image(systemName: "camera.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
            }
        }
        .offset(y: -20)
        .fullScreenCover(isPresented: $showCamera) {
            CameraView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PhotoManager())
        .environmentObject(ProjectManager())
        .environmentObject(CalendarManager())
        .environmentObject(SettingsManager())
}
