import Foundation

struct Photo: Identifiable, Codable, Equatable {
    let id: UUID
    var imageFileName: String
    var assignedDate: Date
    var projectId: UUID?
    var notes: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        imageFileName: String,
        assignedDate: Date,
        projectId: UUID? = nil,
        notes: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.imageFileName = imageFileName
        self.assignedDate = assignedDate
        self.projectId = projectId
        self.notes = notes
        self.createdAt = createdAt
    }

    var imageURL: URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent("Photos").appendingPathComponent(imageFileName)
    }
}
