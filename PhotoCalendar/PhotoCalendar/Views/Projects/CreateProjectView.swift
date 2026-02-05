import SwiftUI

struct CreateProjectView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var projectManager: ProjectManager

    @State private var name: String = ""
    @State private var selectedColor: ProjectColor = .blue
    @State private var hasStartDate: Bool = false
    @State private var startDate: Date = Date()
    @State private var hasEndDate: Bool = false
    @State private var endDate: Date = Date().adding(days: 7)
    @State private var notes: String = ""

    var onProjectCreated: ((Project) -> Void)?

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Project Name")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)

                        TextField("Enter project name", text: $name)
                            .padding()
                            .background(Color.appCardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }

                    // Color picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)

                        ProjectColorPicker(selectedColor: $selectedColor)
                    }

                    // Timeline section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Timeline (Optional)")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)

                        // Start date toggle and picker
                        VStack(spacing: 12) {
                            Toggle("Set Start Date", isOn: $hasStartDate)
                                .tint(.appPrimary)

                            if hasStartDate {
                                DatePicker(
                                    "Start Date",
                                    selection: $startDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.compact)
                            }
                        }
                        .padding()
                        .background(Color.appCardBackground)
                        .cornerRadius(12)

                        // End date toggle and picker
                        VStack(spacing: 12) {
                            Toggle("Set End Date", isOn: $hasEndDate)
                                .tint(.appPrimary)

                            if hasEndDate {
                                DatePicker(
                                    "End Date",
                                    selection: $endDate,
                                    in: startDate...,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.compact)
                            }
                        }
                        .padding()
                        .background(Color.appCardBackground)
                        .cornerRadius(12)
                    }

                    // Notes field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (Optional)")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)

                        TextEditor(text: $notes)
                            .frame(minHeight: 100)
                            .padding()
                            .background(Color.appCardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }

                    // Preview card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preview")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)

                        ProjectCardView(
                            project: Project(
                                name: name.isEmpty ? "Project Name" : name,
                                color: selectedColor,
                                startDate: hasStartDate ? startDate : nil
                            )
                        )
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createProject()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
        }
    }

    private func createProject() {
        let project = projectManager.createProject(
            name: name.trimmingCharacters(in: .whitespaces),
            color: selectedColor,
            startDate: hasStartDate ? startDate : nil,
            endDate: hasEndDate ? endDate : nil,
            notes: notes
        )

        onProjectCreated?(project)
        dismiss()
    }
}

struct EditProjectView: View {
    let project: Project

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var projectManager: ProjectManager

    @State private var name: String = ""
    @State private var selectedColor: ProjectColor = .blue
    @State private var hasStartDate: Bool = false
    @State private var startDate: Date = Date()
    @State private var hasEndDate: Bool = false
    @State private var endDate: Date = Date()
    @State private var notes: String = ""

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Project Name")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)

                        TextField("Enter project name", text: $name)
                            .padding()
                            .background(Color.appCardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }

                    // Color picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)

                        ProjectColorPicker(selectedColor: $selectedColor)
                    }

                    // Timeline section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Timeline")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)

                        VStack(spacing: 12) {
                            Toggle("Set Start Date", isOn: $hasStartDate)
                                .tint(.appPrimary)

                            if hasStartDate {
                                DatePicker(
                                    "Start Date",
                                    selection: $startDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.compact)
                            }
                        }
                        .padding()
                        .background(Color.appCardBackground)
                        .cornerRadius(12)

                        VStack(spacing: 12) {
                            Toggle("Set End Date", isOn: $hasEndDate)
                                .tint(.appPrimary)

                            if hasEndDate {
                                DatePicker(
                                    "End Date",
                                    selection: $endDate,
                                    in: startDate...,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.compact)
                            }
                        }
                        .padding()
                        .background(Color.appCardBackground)
                        .cornerRadius(12)
                    }

                    // Notes field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)

                        TextEditor(text: $notes)
                            .frame(minHeight: 100)
                            .padding()
                            .background(Color.appCardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
            .onAppear {
                loadProjectData()
            }
        }
    }

    private func loadProjectData() {
        name = project.name
        selectedColor = project.color
        hasStartDate = project.startDate != nil
        startDate = project.startDate ?? Date()
        hasEndDate = project.endDate != nil
        endDate = project.endDate ?? Date()
        notes = project.notes
    }

    private func saveChanges() {
        var updatedProject = project
        updatedProject.name = name.trimmingCharacters(in: .whitespaces)
        updatedProject.color = selectedColor
        updatedProject.startDate = hasStartDate ? startDate : nil
        updatedProject.endDate = hasEndDate ? endDate : nil
        updatedProject.notes = notes

        projectManager.updateProject(updatedProject)
        dismiss()
    }
}

#Preview {
    CreateProjectView()
        .environmentObject(ProjectManager())
}
