import Foundation
import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    // MARK: - Private Properties
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    // MARK: - Public Methods
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.mediaSize = 51
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
