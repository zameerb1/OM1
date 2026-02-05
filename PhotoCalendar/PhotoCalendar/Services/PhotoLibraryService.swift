import Foundation
import Photos
import UIKit

class PhotoLibraryService {
    static let shared = PhotoLibraryService()

    private init() {}

    // MARK: - Authorization

    func requestAuthorization() async -> PHAuthorizationStatus {
        await PHPhotoLibrary.requestAuthorization(for: .addOnly)
    }

    var isAuthorized: Bool {
        PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized
    }

    // MARK: - Save to Photos

    func saveToPhotoLibrary(image: UIImage) async throws {
        let status = await requestAuthorization()

        guard status == .authorized else {
            throw PhotoLibraryError.notAuthorized
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges {
                PHAssetCreationRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if success {
                    continuation.resume()
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: PhotoLibraryError.saveFailed)
                }
            }
        }
    }

    func saveMultipleToPhotoLibrary(images: [UIImage]) async throws {
        let status = await requestAuthorization()

        guard status == .authorized else {
            throw PhotoLibraryError.notAuthorized
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges {
                for image in images {
                    PHAssetCreationRequest.creationRequestForAsset(from: image)
                }
            } completionHandler: { success, error in
                if success {
                    continuation.resume()
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: PhotoLibraryError.saveFailed)
                }
            }
        }
    }
}

enum PhotoLibraryError: LocalizedError {
    case notAuthorized
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Photo library access is not authorized. Please enable it in Settings."
        case .saveFailed:
            return "Failed to save the photo to the photo library."
        }
    }
}
