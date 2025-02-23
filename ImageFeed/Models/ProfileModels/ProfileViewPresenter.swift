import Foundation
import UIKit

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    // MARK: - Public Methods

    func viewDidLoad() {
        loadProfile(from: profileService.profile)
        loadAvatar(from: profileImageService.avatarURL)
    }

    func loadAvatar(from url: URL?) {
        view?.updateAvatar(from: url)
    }

    func loadProfile(from profile: Profile?) {
        view?.updateProfile(profile: profile)
    }
  
    // MARK: - Private Methods
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}
