import Foundation


final class ProfileService {
    // MARK: - Public Properties
    static let shared = ProfileService()
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask? // для того чтобы смотреть выполняется ли сейчас поход в сеть за токеном
    private var lastToken: String?// для того чтобы запомнить последний токен и потом сравнивать полученный с ним
    private let storage = OAuth2TokenStorage()
    private(set) var profile: Profile?
    private enum AuthServiceError: Error {
        case invalidRequest
    }
    private enum profileResultsConstants {
        static let unsplashGetProfileResultsURLString = "https://api.unsplash.com/me"
    }
    // MARK: - Initializers
    private init() {}
    // MARK: - Public Methods
    func fetchProfile(with token: String, completion: @escaping (Result<Profile, any Error>) -> Void) {

        assert(Thread.isMainThread)

        if task != nil {
            if lastToken != token {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastToken == token {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }

        lastToken = token

        guard let request = makeProfileResultRequest() else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResponseResult, Error>) in
            guard let self else { preconditionFailure("self is unavalible") }
            switch result {
            case .success(let profileResponseResult):
                let profile = Profile(from: profileResponseResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("ProfileService Error - \(error)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastToken = nil
        }
        self.task = task
        task.resume()
    }
    // MARK: - Private Methods
    private func makeProfileResultRequest() -> URLRequest? {
        guard let url = URL(string: profileResultsConstants.unsplashGetProfileResultsURLString) else {
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
