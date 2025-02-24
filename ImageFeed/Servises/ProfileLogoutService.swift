import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    // MARK: - Public Properties
    static let shared = ProfileLogoutService()
    // MARK: - Private Properties
    private let profileService: ProfileService = ProfileService.shared
    private let profileImageService: ProfileImageService = ProfileImageService.shared
    private let imagesListService: ImagesListService = ImagesListService.shared
    // MARK: - Initializers
    private init() { }
    // MARK: - Public Methods
    func logout() {
        cleanCookies()
        cleanToken()
        clearProfileImage()
        clearImageListImages()
    }
    // MARK: - Private Methods
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanToken() {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "Auth token")
        guard removeSuccessful else { preconditionFailure("token not removed")}
    }
    
    private func clearProfileImage() {
        profileImageService.clearAvatarURL()
    }
    
    private func clearImageListImages() {
        imagesListService.clearPhotos()
    }
}

