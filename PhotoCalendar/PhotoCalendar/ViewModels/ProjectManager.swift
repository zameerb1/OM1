import Foundation
import SwiftUI

@MainActor
class ProjectManager: ObservableObject {
    @Published var projects: [Project] = []

    private let projectsKey = "savedProjects"

    init() {
        loadProjects()
    }

    // MARK: - CRUD Operations

    func createProject(name: String, color: ProjectColor = .blue, startDate: Date? = nil, endDate: Date? = nil, notes: String = "") -> Project {
        let project = Project(
            name: name,
            color: color,
            startDate: startDate,
            endDate: endDate,
            notes: notes
        )
        projects.append(project)
        saveProjects()
        return project
    }

    func updateProject(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = project
            saveProjects()
        }
    }

    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
        saveProjects()
    }

    func deleteProject(at offsets: IndexSet) {
        projects.remove(atOffsets: offsets)
        saveProjects()
    }

    // MARK: - Photo Association

    func addPhoto(_ photoId: UUID, to projectId: UUID) {
        if let index = projects.firstIndex(where: { $0.id == projectId }) {
            if !projects[index].photoIds.contains(photoId) {
                projects[index].photoIds.append(photoId)
                saveProjects()
            }
        }
    }

    func removePhoto(_ photoId: UUID, from projectId: UUID) {
        if let index = projects.firstIndex(where: { $0.id == projectId }) {
            projects[index].photoIds.removeAll { $0 == photoId }
            saveProjects()
        }
    }

    // MARK: - Query Methods

    func project(withId id: UUID) -> Project? {
        projects.first { $0.id == id }
    }

    func projects(forDate date: Date) -> [Project] {
        projects.filter { project in
            guard let startDate = project.startDate else { return false }
            if let endDate = project.endDate {
                return date >= startDate.startOfDay && date <= endDate.endOfDay
            }
            return date.isSameDay(as: startDate)
        }
    }

    func projectsWithPhotos(onDate date: Date, photos: [Photo]) -> [Project] {
        let photoIdsOnDate = Set(photos.filter { $0.assignedDate.isSameDay(as: date) }.map { $0.id })
        return projects.filter { project in
            !Set(project.photoIds).isDisjoint(with: photoIdsOnDate)
        }
    }

    var sortedProjects: [Project] {
        projects.sorted { ($0.startDate ?? $0.createdAt) < ($1.startDate ?? $1.createdAt) }
    }

    var recentProjects: [Project] {
        Array(projects.sorted { $0.createdAt > $1.createdAt }.prefix(5))
    }

    // MARK: - Persistence

    private func saveProjects() {
        if let encoded = try? JSONEncoder().encode(projects) {
            UserDefaults.standard.set(encoded, forKey: projectsKey)
        }
    }

    private func loadProjects() {
        if let data = UserDefaults.standard.data(forKey: projectsKey),
           let decoded = try? JSONDecoder().decode([Project].self, from: data) {
            projects = decoded
        }
    }
}
