import Foundation

struct OAuthTokenResponseBody: Decodable {
  let accessToken: String
  let tokenType: String
  let createdAt: Int
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case createdAt = "created_at"
  }
}

final class OAuth2Service {
  
  static let shared = OAuth2Service()
  private init() {}
  
  private let tokenStorage = OAuth2TokenStorage()
  
  func makeOAuthTokenRequest(code: String) -> URLRequest? {
    guard let baseURL = URL(string: "https://unsplash.com") else {
      print ("Ошибка: не удалось создать baseURL")
      return nil
    }
    guard let url = URL(string: "/oauth/token"
                        + "?client_id=\(Constants.accessKey)"
                        + "&client_secret=\(Constants.secretKey)"
                        + "&redirect_uri=\(Constants.redirectURI)"
                        + "&code=\(code)"
                        + "&grant_type=authorization_code",
                        relativeTo: baseURL) else {
      assertionFailure("Не удалось создать URL")
      return nil
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    return request
  }
  
  func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
    guard let request = makeOAuthTokenRequest(code: code) else {
      completion(.failure(NSError(domain: "OAuth2Service", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ошибка создания запроса"])))
      return
    }
    
    URLSession.shared.data(for: request) { [weak self] result in
      switch result {
      case .success(let data):
        do {
          let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
          self?.tokenStorage.token = tokenResponse.accessToken
          completion(.success(tokenResponse.accessToken))
        } catch {
          print("Ошибка декодирования ответа: \(error)")
          completion(.failure(error))
        }
      case .failure(let error):
        print("Ошибка сети или запроса: \(error)")
        completion(.failure(error))
      }
    }.resume()
  }
}

