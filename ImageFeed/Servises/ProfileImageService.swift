import Foundation

final class ProfileImageService {
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask? // для того чтобы смотреть выполняется ли сейчас поход в сеть за токеном
    private let storage = OAuth2TokenStorage()
    private let decoder = SnakeCaseJSONDecoder()
    private(set) var avatarURL: URL?
    private enum AuthServiceError: Error {
        case invalidRequest
    }
    // MARK: - Initializers
    private init() {}
    // MARK: - Public Methods
    func clearAvatarURL() {
        avatarURL = nil
    }
    
    func fetchImageURL(with username: String, completion: @escaping (Result<URL, Error>) -> Void) {
      assert(Thread.isMainThread)
      task?.cancel()

      guard let request = makeProfileResultRequest(username: username) else {
        completion(.failure(AuthServiceError.invalidRequest))
        return
      }

      let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
        guard let self = self else { preconditionFailure("self is unavailable") }

        switch result {
        case .success(let userResult):
          guard let imageURLString = userResult.profileImage.large,
                let imageURL = URL(string: imageURLString) else {
            preconditionFailure("Cannot get image URL or create URL from string")
          }

          self.avatarURL = imageURL
          completion(.success(imageURL))
          NotificationCenter.default.post(
            name: ProfileImageService.didChangeNotification,
            object: self,
            userInfo: ["URL": imageURL]
          )

        case .failure(let error):
          print("ProfileImageService Error - \(error)")
          completion(.failure(error))
        }

        self.task = nil
      }

      self.task = task
      task.resume()
    }
    
    func makeProfileResultRequest(username: String) -> URLRequest? {
        guard let url = URL(string: Constants.unsplashGetProfileImageURLString + username) else {
            assertionFailure("Cant make URL")
            return nil
        }
        
        let token = String(describing: storage.token!)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
