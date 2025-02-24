import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func loadProfile(from profile: Profile?)
    func loadAvatar(from url: URL?)
}
