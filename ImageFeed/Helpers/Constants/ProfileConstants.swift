import Foundation

enum Constants {
    static let unsplashGetProfileImageURLString = "https://api.unsplash.com/users/"
    static let accessKey = "-gomhMdtjmK3aYWEDXdk7PNFGvX3lPmfBBCXF4ssIfw"
    static let secretKey = "5Gj7-AYC4dW17imPD7Q60_LcGMwgaVoNL9R5glgDTBI"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = defaultBaseURLgetter
    static private var defaultBaseURLgetter: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {preconditionFailure("Unable to construct unsplashUrl")}
        return url
    }
}
