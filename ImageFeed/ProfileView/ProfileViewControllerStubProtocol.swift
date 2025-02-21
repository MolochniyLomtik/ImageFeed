import UIKit

public protocol ProfileViewControllerStubProtocol {
    var fullNameTextLabel: UILabel { get set }
    var profileLoginTextLabel: UILabel { get set }
    var profileStatusTextLabel: UILabel { get set }
    
    func updateProfile(profile: Profile)
}
