import Foundation
import UIKit
import Kingfisher
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {
    var presenter: ProfileViewPresenterProtocol?
    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage()
    private var profile: Profile?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageView: UIImageView?
    private var exitButton: UIButton?
    private var fullNameTextLabel: UILabel?
    private var profileLoginTextLabel: UILabel?
    private var profileStatusTextLabel: UILabel?
    private var favoritesTextLabel: UILabel?
    private var noFavoritesPhotoPlaceHolder: UIImageView?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileScreen()
        updateProfileDetails()
        addProfileImageObserver()
        updateAvatar()
    }
    // MARK: - Actions
    @objc
    private func didTapExitButton() {
        showAlert()
    }

    func logoutDidTapped() {
      profileLogoutService.logout()
      switchToSplashViewController()
    }
    // MARK: - Private Methods
    private func showAlert() {
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        let alertModel = AlertModel(
          title: "Пока Пока!",
          message: "Уверены что хотите выйти?",
          buttonText: "Да",
          buttonText2: "Нет",
          completion: { self.logoutDidTapped() }
        )
        AlertPresenter.showAlert(model: alertModel, vc: self)
      }
    }

    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    private func addProfileImageObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar()
                }
            )
    }
    
    private func updateAvatar() {
      guard
        let profileImageURL = ProfileImageService.shared.avatarURL,
        let pick = profileImageView
      else { return }

      pick.kf.indicatorType = .activity
      let processor = RoundCornerImageProcessor(cornerRadius: 0, backgroundColor: .ypBlack)
      pick.kf.setImage(with: profileImageURL, options: [.processor(processor)])
    }

    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else {
            return
        }
        self.fullNameTextLabel?.text = profile.name
        self.profileLoginTextLabel?.text = profile.loginName
        self.profileStatusTextLabel?.text = profile.bio
    }
    
    private func setProfileScreen() {
        view.backgroundColor = .ypBlack
        setProfileImage()
        setExitButton()
        setFullNameTextLabel()
        setProfileLoginTextLabel()
        setProfileStatusTextLabel()
    }
    
    private func setProfileImage() {
        let profileImageView = UIImageView()
        profileImageView.frame.size = CGSize(width: 70, height: 70)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
        let profileImage = UIImage(named: "userPick")
        profileImageView.image = profileImage
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 32).isActive = true
        self.profileImageView = profileImageView
    }
    
    private func setExitButton() {
        guard let exitImage = UIImage(named: "logout"),
              let profileImageView = self.profileImageView else {return}
        
        let exitButton = UIButton.systemButton(
            with: exitImage,
            target: self,
            action: #selector(Self.didTapExitButton)
        )
        exitButton.tintColor = UIColor(hex: "#F56B6C")
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        self.exitButton = exitButton
    }
    
    private func setFullNameTextLabel() {
        guard let profileImageView = self.profileImageView else { return }
        let fullNameTextLabel = UILabel()
        view.addSubview(fullNameTextLabel)
        fullNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameTextLabel.text = ""
        fullNameTextLabel.textColor = .white
        fullNameTextLabel.font = .boldSystemFont(ofSize: 23)
        
        fullNameTextLabel.widthAnchor.constraint(equalToConstant: 235).isActive = true
        fullNameTextLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        fullNameTextLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        fullNameTextLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        self.fullNameTextLabel = fullNameTextLabel
    }
    
    private func setProfileLoginTextLabel() {
        guard let fullNameTextLabel = self.fullNameTextLabel else { return }
        let profileLoginTextLabel = UILabel()
        view.addSubview(profileLoginTextLabel)
        profileLoginTextLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLoginTextLabel.text = ""
        profileLoginTextLabel.textColor = .white
        profileLoginTextLabel.font = .systemFont(ofSize: 13)
        
        profileLoginTextLabel.widthAnchor.constraint(equalToConstant: 99).isActive = true
        profileLoginTextLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        profileLoginTextLabel.leadingAnchor.constraint(equalTo: fullNameTextLabel.leadingAnchor).isActive = true
        profileLoginTextLabel.topAnchor.constraint(equalTo: fullNameTextLabel.bottomAnchor, constant: 8).isActive = true
        self.profileLoginTextLabel = profileLoginTextLabel
    }
    
    private func setProfileStatusTextLabel() {
        guard let profileLoginTextLabel = self.profileLoginTextLabel else { return }
        let profileStatusTextLabel = UILabel()
        view.addSubview(profileStatusTextLabel)
        profileStatusTextLabel.translatesAutoresizingMaskIntoConstraints = false
        profileStatusTextLabel.text = ""
        profileStatusTextLabel.textColor = .white
        profileStatusTextLabel.font = .systemFont(ofSize: 13)
        
        profileStatusTextLabel.widthAnchor.constraint(equalToConstant: 77).isActive = true
        profileStatusTextLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        profileStatusTextLabel.leadingAnchor.constraint(equalTo: profileLoginTextLabel.leadingAnchor).isActive = true
        profileStatusTextLabel.topAnchor.constraint(equalTo: profileLoginTextLabel.bottomAnchor, constant: 8).isActive = true
        self.profileStatusTextLabel = profileStatusTextLabel
    }
}

