import UIKit

protocol AuthViewControllerDelegate: AnyObject {
  func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
  private let ShowWebViewSegueIdentifier = "ShowWebView"
  
  weak var delegate: AuthViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureBackButton()
  }
  
  private func configureBackButton() {
    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ShowWebViewSegueIdentifier {
      guard
        let webViewViewController = segue.destination as? WebViewViewController
      else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
      webViewViewController.delegate = self
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
}

extension AuthViewController: WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    delegate?.authViewController(self, didAuthenticateWithCode: code)
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    dismiss(animated: true)
  }
}
