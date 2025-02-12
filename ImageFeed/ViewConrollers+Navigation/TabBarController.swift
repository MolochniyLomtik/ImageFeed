import UIKit

final class TabBarController: UITabBarController {
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let imagesListViewController = ImagesListViewController()
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "profileScreenActive"),
            selectedImage: nil
        )
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "mainScreenActive"),
            selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
        
        setUITabBarAppearance()
    }
    
    private func setUITabBarAppearance() {
        let uITabBarAppearance = UITabBarAppearance()
        uITabBarAppearance.configureWithOpaqueBackground()
        uITabBarAppearance.backgroundColor = .ypBlack
        uITabBarAppearance.stackedLayoutAppearance.selected.iconColor = .white
        tabBar.standardAppearance = uITabBarAppearance
    }
}
