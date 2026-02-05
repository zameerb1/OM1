import Foundation
import AVFoundation
import UIKit

class CameraService {
    static let shared = CameraService()

    private init() {}

    // MARK: - Authorization

    func requestAuthorization() async -> AVAuthorizationStatus {
        await AVCaptureDevice.requestAccess(for: .video)
        return AVCaptureDevice.authorizationStatus(for: .video)
    }

    var isAuthorized: Bool {
        AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }

    var authorizationStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }

    // MARK: - Camera Availability

    var isCameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    var isFlashAvailable: Bool {
        guard let device = AVCaptureDevice.default(for: .video) else { return false }
        return device.hasFlash
    }
}
