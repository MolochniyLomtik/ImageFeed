import Foundation

final class OAuth2TokenStorage {
  private let tokenKey = "Bearer Token"
  
  var token: String? {
    get {
      return UserDefaults.standard.string(forKey: tokenKey)
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: tokenKey)
    }
  }
}
