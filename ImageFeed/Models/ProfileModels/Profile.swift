import Foundation

struct Profile {
    // MARK: - Public Properties
    var username: String
    var name: String
    var firstName: String
    var lastName: String
    var loginName: String {
        get {
            return "@\(username)"
        }
    }
    var bio: String?
    
    init(from result: ProfileResponseResult) {
        self.username = result.username
        self.name = result.name ?? ""
        self.firstName = result.firstName ?? ""
        self.lastName = result.lastName ?? ""
        self.bio = result.bio ?? ""
    }
}
