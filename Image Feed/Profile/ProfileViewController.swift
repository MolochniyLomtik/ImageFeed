import UIKit

final class ProfileViewController: UIViewController {

  private var nameLabel: UILabel?
  private var loginNameLabel: UILabel?
  private var descriptionLabel: UILabel?

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(named: "YP Black") // Установите цвет фона для удобства

    // Avatar Image View
    let profileImage = UIImage(named: "avatar")
    let imageView = UIImageView(image: profileImage)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    view.addSubview(imageView)

    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      imageView.widthAnchor.constraint(equalToConstant: 70),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor) // Соотношение 1:1
    ])

    // Name Label
    nameLabel = UILabel()
    nameLabel?.text = "Екатерина Новикова"
    nameLabel?.textColor = UIColor(named: "YP White")
    nameLabel?.translatesAutoresizingMaskIntoConstraints = false
    nameLabel?.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
    view.addSubview(nameLabel!)

    NSLayoutConstraint.activate([
      nameLabel!.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
      nameLabel!.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
    ])

    // Login Name Label
    loginNameLabel = UILabel()
    loginNameLabel?.text = "@ekaterina_nov"
    loginNameLabel?.translatesAutoresizingMaskIntoConstraints = false
    loginNameLabel?.textColor = UIColor(named: "YP Gray")
    loginNameLabel?.font = UIFont.systemFont(ofSize: 13)
    view.addSubview(loginNameLabel!)

    NSLayoutConstraint.activate([
      loginNameLabel!.leadingAnchor.constraint(equalTo: nameLabel!.leadingAnchor),
      loginNameLabel!.trailingAnchor.constraint(equalTo: nameLabel!.trailingAnchor),
      loginNameLabel!.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8)
    ])

    // Description Label
    descriptionLabel = UILabel()
    descriptionLabel?.text = "Hello, world!"
    descriptionLabel?.textColor = UIColor(named: "YP White")
    descriptionLabel?.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel?.font = UIFont.systemFont(ofSize: 13)
    view.addSubview(descriptionLabel!)

    NSLayoutConstraint.activate([
      descriptionLabel!.leadingAnchor.constraint(equalTo: loginNameLabel!.leadingAnchor),
      descriptionLabel!.trailingAnchor.constraint(equalTo: loginNameLabel!.trailingAnchor),
      descriptionLabel!.topAnchor.constraint(equalTo: loginNameLabel!.bottomAnchor, constant: 8)
    ])

    // Logout Button
    let logoutButton = UIButton.systemButton(
      with: UIImage(systemName: "ipad.and.arrow.forward")!,
      target: self,
      action: #selector(didTapButton)
    )
    logoutButton.tintColor = UIColor(named: "YP Red")
    logoutButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(logoutButton)

    NSLayoutConstraint.activate([
      logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      logoutButton.widthAnchor.constraint(equalToConstant: 44),
      logoutButton.heightAnchor.constraint(equalToConstant: 44),
      logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
    ])
  }

  @objc
  private func didTapButton() {
  }
}
