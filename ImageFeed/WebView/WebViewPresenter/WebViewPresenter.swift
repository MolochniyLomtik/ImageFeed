import Foundation
import UIKit
@preconcurrency import WebKit

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - IB Outlets

    // MARK: - Public Properties
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    // MARK: - Private Properties
    
    // MARK: - Initializers
    init(authHelper: AuthHelperProtocol) {
            self.authHelper = authHelper
        }
    // MARK: - Overrides Methods
    func viewDidLoad() {
        loadAuthViewAndUpdateProgressView()
    }
    // MARK: - IB Actions

    // MARK: - Public Methods
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value-1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    // MARK: - Private Methods
    private func loadAuthViewAndUpdateProgressView() {
        guard let request = authHelper.authRequest() else { return }
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
}
