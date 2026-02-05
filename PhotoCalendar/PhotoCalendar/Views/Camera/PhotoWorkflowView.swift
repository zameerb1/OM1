import SwiftUI

struct PhotoWorkflowView: View {
    let capturedImage: UIImage
    var onComplete: () -> Void

    @EnvironmentObject var photoManager: PhotoManager
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var settingsManager: SettingsManager

    @State private var currentStep: WorkflowStep = .preview
    @State private var selectedDate: Date = Date().adding(days: 1)
    @State private var selectedProject: Project?
    @State private var photoNotes: String = ""
    @State private var showCreateProject = false

    enum WorkflowStep {
        case preview
        case dateSelection
        case projectSelection
        case notes
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress indicator
                ProgressBar(currentStep: currentStep)
                    .padding()

                switch currentStep {
                case .preview:
                    PhotoPreviewStep(
                        image: capturedImage,
                        onContinue: { currentStep = .dateSelection },
                        onRetake: { onComplete() }
                    )

                case .dateSelection:
                    DateSelectionStep(
                        selectedDate: $selectedDate,
                        onContinue: { currentStep = .projectSelection },
                        onBack: { currentStep = .preview }
                    )

                case .projectSelection:
                    ProjectSelectionStep(
                        selectedProject: $selectedProject,
                        showCreateProject: $showCreateProject,
                        onContinue: { currentStep = .notes },
                        onBack: { currentStep = .dateSelection }
                    )

                case .notes:
                    NotesStep(
                        notes: $photoNotes,
                        onSave: savePhoto,
                        onBack: { currentStep = .projectSelection }
                    )
                }
            }
            .background(Color.appBackground)
            .sheet(isPresented: $showCreateProject) {
                CreateProjectView { project in
                    selectedProject = project
                }
            }
        }
    }

    private func savePhoto() {
        _ = photoManager.savePhoto(
            image: capturedImage,
            assignedDate: selectedDate,
            projectId: selectedProject?.id,
            notes: photoNotes
        )

        if let project = selectedProject, let photo = photoManager.photos.last {
            projectManager.addPhoto(photo.id, to: project.id)
        }

        onComplete()
    }
}

struct ProgressBar: View {
    let currentStep: PhotoWorkflowView.WorkflowStep

    private var stepIndex: Int {
        switch currentStep {
        case .preview: return 0
        case .dateSelection: return 1
        case .projectSelection: return 2
        case .notes: return 3
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<4) { index in
                Capsule()
                    .fill(index <= stepIndex ? Color.appPrimary : Color.gray.opacity(0.3))
                    .frame(height: 4)
            }
        }
    }
}

struct PhotoPreviewStep: View {
    let image: UIImage
    var onContinue: () -> Void
    var onRetake: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Review Photo")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.appTextPrimary)

            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(16)
                .padding(.horizontal)

            Spacer()

            VStack(spacing: 12) {
                Button(action: onContinue) {
                    Text("Use This Photo")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary)
                        .cornerRadius(12)
                }

                Button(action: onRetake) {
                    Text("Retake")
                        .font(.headline)
                        .foregroundColor(.appPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}

struct DateSelectionStep: View {
    @Binding var selectedDate: Date
    var onContinue: () -> Void
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Date")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.appTextPrimary)

            Text("When should this photo be scheduled for?")
                .font(.body)
                .foregroundColor(.appTextSecondary)

            CompactCalendarView(selectedDate: $selectedDate)
                .padding(.horizontal)

            Text("Selected: \(selectedDate.formattedDate)")
                .font(.headline)
                .foregroundColor(.appPrimary)
                .padding()
                .background(Color.appPrimary.opacity(0.1))
                .cornerRadius(12)

            Spacer()

            VStack(spacing: 12) {
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary)
                        .cornerRadius(12)
                }

                Button(action: onBack) {
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(.appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}

struct ProjectSelectionStep: View {
    @Binding var selectedProject: Project?
    @Binding var showCreateProject: Bool
    var onContinue: () -> Void
    var onBack: () -> Void

    @EnvironmentObject var projectManager: ProjectManager

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Project")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.appTextPrimary)

            Text("Assign this photo to a project (optional)")
                .font(.body)
                .foregroundColor(.appTextSecondary)

            ScrollView {
                VStack(spacing: 12) {
                    // No project option
                    ProjectSelectionCard(
                        project: Project(name: "No Project", color: .blue),
                        isSelected: selectedProject == nil
                    ) {
                        selectedProject = nil
                    }
                    .opacity(0.7)

                    // Existing projects
                    ForEach(projectManager.projects) { project in
                        ProjectSelectionCard(
                            project: project,
                            isSelected: selectedProject?.id == project.id
                        ) {
                            selectedProject = project
                        }
                    }

                    // Create new project
                    NewProjectCard {
                        showCreateProject = true
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            VStack(spacing: 12) {
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary)
                        .cornerRadius(12)
                }

                Button(action: onBack) {
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(.appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}

struct NotesStep: View {
    @Binding var notes: String
    var onSave: () -> Void
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Notes")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.appTextPrimary)

            Text("Add any notes about this photo (optional)")
                .font(.body)
                .foregroundColor(.appTextSecondary)

            TextEditor(text: $notes)
                .frame(minHeight: 150)
                .padding()
                .background(Color.appCardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)

            Spacer()

            VStack(spacing: 12) {
                Button(action: onSave) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Save Photo")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appPrimary)
                    .cornerRadius(12)
                }

                Button(action: onBack) {
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(.appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    PhotoWorkflowView(capturedImage: UIImage(systemName: "photo")!) {}
        .environmentObject(PhotoManager())
        .environmentObject(ProjectManager())
        .environmentObject(SettingsManager())
}
