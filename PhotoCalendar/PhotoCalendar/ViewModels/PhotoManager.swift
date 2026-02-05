import Foundation
import SwiftUI
import UIKit

@MainActor
class PhotoManager: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isLoadingPhotos: Bool = false

    private let photosKey = "savedPhotos"
    private let photosDirectory = "Photos"

    init() {
        createPhotosDirectoryIfNeeded()
        loadPhotos()
    }

    // MARK: - Directory Management

    private var photosDirectoryURL: URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(photosDirectory)
    }

    private func createPhotosDirectoryIfNeeded() {
        guard let directoryURL = photosDirectoryURL else { return }
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        }
    }

    // MARK: - Photo Operations

    func savePhoto(image: UIImage, assignedDate: Date, projectId: UUID?, notes: String = "") -> Photo? {
        guard let directoryURL = photosDirectoryURL else { return nil }

        let photoId = UUID()
        let fileName = "\(photoId.uuidString).jpg"
        let fileURL = directoryURL.appendingPathComponent(fileName)

        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }

        do {
            try imageData.write(to: fileURL)

            let photo = Photo(
                id: photoId,
                imageFileName: fileName,
                assignedDate: assignedDate,
                projectId: projectId,
                notes: notes
            )

            photos.append(photo)
            savePhotoMetadata()

            return photo
        } catch {
            print("Error saving photo: \(error)")
            return nil
        }
    }

    func updatePhoto(_ photo: Photo) {
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            photos[index] = photo
            savePhotoMetadata()
        }
    }

    func deletePhoto(_ photo: Photo) {
        // Delete the image file
        if let fileURL = photo.imageURL {
            try? FileManager.default.removeItem(at: fileURL)
        }

        // Remove from array
        photos.removeAll { $0.id == photo.id }
        savePhotoMetadata()
    }

    func deletePhotos(_ photosToDelete: [Photo]) {
        for photo in photosToDelete {
            if let fileURL = photo.imageURL {
                try? FileManager.default.removeItem(at: fileURL)
            }
        }
        let idsToDelete = Set(photosToDelete.map { $0.id })
        photos.removeAll { idsToDelete.contains($0.id) }
        savePhotoMetadata()
    }

    // MARK: - Image Loading

    func loadImage(for photo: Photo) -> UIImage? {
        guard let fileURL = photo.imageURL,
              let imageData = try? Data(contentsOf: fileURL),
              let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }

    // MARK: - Query Methods

    func photo(withId id: UUID) -> Photo? {
        photos.first { $0.id == id }
    }

    func photos(forDate date: Date) -> [Photo] {
        photos.filter { $0.assignedDate.isSameDay(as: date) }
    }

    func photos(forProject projectId: UUID) -> [Photo] {
        photos.filter { $0.projectId == projectId }
    }

    func photos(forProject projectId: UUID, onDate date: Date) -> [Photo] {
        photos.filter { $0.projectId == projectId && $0.assignedDate.isSameDay(as: date) }
    }

    func datesWithPhotos(inMonth date: Date) -> Set<Date> {
        let monthPhotos = photos.filter { $0.assignedDate.isSameMonth(as: date) }
        return Set(monthPhotos.map { $0.assignedDate.startOfDay })
    }

    func hasPhotos(onDate date: Date) -> Bool {
        photos.contains { $0.assignedDate.isSameDay(as: date) }
    }

    func photoCount(forDate date: Date) -> Int {
        photos.filter { $0.assignedDate.isSameDay(as: date) }.count
    }

    var sortedPhotos: [Photo] {
        photos.sorted { $0.assignedDate < $1.assignedDate }
    }

    // MARK: - Persistence

    private func savePhotoMetadata() {
        if let encoded = try? JSONEncoder().encode(photos) {
            UserDefaults.standard.set(encoded, forKey: photosKey)
        }
    }

    private func loadPhotos() {
        if let data = UserDefaults.standard.data(forKey: photosKey),
           let decoded = try? JSONDecoder().decode([Photo].self, from: data) {
            photos = decoded
        }
    }
}
