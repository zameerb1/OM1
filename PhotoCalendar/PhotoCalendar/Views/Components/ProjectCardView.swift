import SwiftUI

struct ProjectCardView: View {
    let project: Project
    var photoCount: Int = 0
    var isCompact: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            // Project color indicator
            RoundedRectangle(cornerRadius: 8)
                .fill(project.color.gradient)
                .frame(width: isCompact ? 40 : 50, height: isCompact ? 40 : 50)
                .overlay(
                    Image(systemName: project.color.icon)
                        .font(isCompact ? .body : .title3)
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(project.name)
                    .font(isCompact ? .subheadline : .headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.appTextPrimary)
                    .lineLimit(1)

                if !isCompact {
                    HStack(spacing: 8) {
                        if let startDate = project.startDate {
                            Label(startDate.formattedShortDate, systemImage: "calendar")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }

                        if photoCount > 0 {
                            Label("\(photoCount)", systemImage: "photo")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.appTextSecondary)
        }
        .padding(isCompact ? 8 : 12)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ProjectSelectionCard: View {
    let project: Project
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(project.color.gradient)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: project.color.icon)
                            .foregroundColor(.white)
                    )

                Text(project.name)
                    .font(.body)
                    .foregroundColor(.appTextPrimary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.appPrimary)
                }
            }
            .padding(12)
            .background(isSelected ? Color.appPrimary.opacity(0.1) : Color.appCardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.appPrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NewProjectCard: View {
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "plus")
                            .foregroundColor(.appPrimary)
                    )

                Text("Create New Project")
                    .font(.body)
                    .foregroundColor(.appPrimary)

                Spacer()
            }
            .padding(12)
            .background(Color.appCardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appPrimary.opacity(0.3), lineWidth: 1)
                    .strokeStyle(style: StrokeStyle(lineWidth: 1, dash: [5]))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProjectColorPicker: View {
    @Binding var selectedColor: ProjectColor

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ProjectColor.allCases, id: \.self) { color in
                    Circle()
                        .fill(color.gradient)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                        )
                        .overlay(
                            Circle()
                                .stroke(color.color.opacity(0.5), lineWidth: selectedColor == color ? 1 : 0)
                        )
                        .scaleEffect(selectedColor == color ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedColor)
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ProjectCardView(
            project: Project(name: "Kitchen Renovation", color: .blue),
            photoCount: 5
        )

        ProjectSelectionCard(
            project: Project(name: "Bathroom Fix", color: .green),
            isSelected: true
        ) {}

        NewProjectCard {}
    }
    .padding()
    .background(Color.appBackground)
}
