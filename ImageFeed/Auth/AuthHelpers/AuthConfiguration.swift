import Foundation

enum Constants {
    static let accessKey = "Xv5HvF9p0Y-kfgKfhqncEAX1_5aAXu0qcYCyBRf8Gzs"
    static let secretKey = "UEyMOLEg3KX6W_5DG92DO5bMn1P_BfvBjTWQzF1sGS4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    static let unsplashGetProfileImageURLString = "https://api.unsplash.com/users/"
    
    static let defaultBaseURL: URL = defaultBaseURLgetter
    static let defaultBaseURLString = "https://api.unsplash.com"
    
    static private var defaultBaseURLgetter: URL {
        guard let url = URL(string: "https://api.unsplash.com") else { preconditionFailure("Unable to construct unsplashUrl") }
        return url
    }
    
}

struct AuthConfiguration {
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
