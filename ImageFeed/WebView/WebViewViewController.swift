import Foundation
import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController, WKNavigationDelegate, WebViewViewControllerProtocol {
    // MARK: - Public Properties
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    // MARK: - Private Properties
    private var backButton: UIButton?
    private var webView: WKWebView?
    private var progressView: UIProgressView?
    private var estimatedProgressObservation: NSKeyValueObservation?
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebViewController()
        guard let webView else { preconditionFailure("unwrap error webView") }
        webView.navigationDelegate = self
        view.backgroundColor = .ypBlack
        addNewKVO()
        presenter?.viewDidLoad()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            guard let webView else {
                print("unwrap error webView")
                return
            }
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    // MARK: - IB Actions
    @objc
    private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Public Methods
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func load(request: URLRequest) {
        guard let webView else {
            print("WebView Doesnt Exist")
            return
        }
        webView.load(request)
    }
    
    func setProgressValue (_ newValue: Float) {
        guard let progressView else { preconditionFailure("unwrap error progressView") }
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        guard let progressView else { preconditionFailure("unwrap error progressView") }
        progressView.isHidden = isHidden
    }
    
    // MARK: - Private Methods
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
    private func addNewKVO() {
        guard let webView else { preconditionFailure("unwrap error webView") }
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             }
        )
    }

    private func setWebViewController() {
        view.backgroundColor = .ypBlack
        setWebView()
        setBackButton()
        setProgressView()
    }
    
    private func setWebView() {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.accessibilityIdentifier = "UnsplashWebView"
        self.webView = webView
    }
    
    private func setBackButton() {
        guard let webView else { preconditionFailure("unwrap error webView") }
        guard let chevronImage = UIImage(named: "chevronBackward") else { preconditionFailure("chevron Image doesn't exist")}
        
        let backButton = UIButton.systemButton(
            with: chevronImage,
            target: self,
            action: #selector(Self.didTapBackButton)
        )
        backButton.tintColor = .ypBlack
        backButton.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(backButton)
        
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 9).isActive = true
        backButton.topAnchor.constraint(equalTo: webView.layoutMarginsGuide.topAnchor, constant: 9).isActive = true
        
        self.backButton = backButton
    }
    
    private func setProgressView() {
        guard let webView else { preconditionFailure("unwrap error webView") }
        guard let backButton = self.backButton else { preconditionFailure("back button doesn't exist")}
        let progressView = UIProgressView()
        progressView.tintColor = .ypBlack
        progressView.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(progressView)
        progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor).isActive = true
        self.progressView = progressView
    }
}
