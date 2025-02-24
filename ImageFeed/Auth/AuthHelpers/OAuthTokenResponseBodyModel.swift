import Foundation

struct OAuthTokenResponseBody: Decodable {
    // MARK: - Public Properties
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
