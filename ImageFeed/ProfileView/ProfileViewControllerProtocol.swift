import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateProfile(profile: Profile?)
    func updateAvatar(from url: URL?)
}
