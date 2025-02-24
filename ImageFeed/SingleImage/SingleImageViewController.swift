import UIKit

final class SingleImageViewController: UIViewController {
  // MARK: - Public Properties
  var image: Photo? {
    didSet {
      guard let image else { return }
      imageView.kf.indicatorType = .activity
      imageView.kf.setImage(with: image.largeImageURL)
      imageView.frame.size = image.size
    }
  }

  // MARK: - Private Properties
  private var imageView = UIImageView()
  private var backButton: UIButton?
  private var shareButton: UIButton?
  private var scrollView = UIScrollView()
  private var initialImageFrame: CGRect?

  // MARK: - Overrides Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setSingleImageScreen()
    view.backgroundColor = .ypBlack
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    updateMinZoomScaleForSize(view.bounds.size)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if imageView.image == nil {
      loadImage()
    }
  }

  // MARK: - IB Actions
  @objc
  private func didTapBackButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  @objc
  private func didTapShareButton(_ sender: Any) {
    guard let image else { return }
    let share = UIActivityViewController(
      activityItems: [image],
      applicationActivities: nil
    )
    present(share, animated: true, completion: nil)
  }

  // MARK: - Private Methods
  private func setSingleImageScreen() {
    setImageView()
    setScrollView()
    setBackButton()
    setShareButton()
  }

  private func showError() {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      let alertModel = AlertModel(
        title: "Что-то пошло не так(",
        message: "Попробовать ещё раз?",
        buttonText: "Повторить", buttonText2: "Не надо",
        completion:  { [weak self] in
          guard let self else { return }
          UIBlockingProgressHUD.show()
          self.loadImage()
        }
      )
      AlertPresenter.showAlert(model: alertModel, vc: self)
    }
  }

  private var isImageLoading = false

  private func loadImage() {
    guard let image else { return }

    isImageLoading = true
    UIBlockingProgressHUD.show()

    imageView.kf.setImage(with: image.largeImageURL) { [weak self] result in
      guard let self else { return }

      UIBlockingProgressHUD.dismiss()
      self.isImageLoading = false

      switch result {
      case .success(let imageResult):
        self.imageView.image = imageResult.image
        self.imageView.contentMode = .scaleAspectFit
        self.updateScrollViewForImage()

      case .failure:
        self.showError()
      }
    }
  }

  private func setImageView() {
    guard let image else { return }
    let imageView = UIImageView()
    UIBlockingProgressHUD.show()
    imageView.frame.size = image.size
    loadImage()
    self.imageView = imageView
  }

  private func setScrollView() {
    scrollView.delegate = self
    scrollView.minimumZoomScale = 0.1
    scrollView.maximumZoomScale = 1.25
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(imageView)
    view.addSubview(scrollView)

    scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
  }

  private func setBackButton() {
    guard let buttonImage = UIImage(named: "chevronBackward") else { preconditionFailure("backButton button image doesn't exist") }
    let backButton = UIButton.systemButton(
      with: buttonImage,
      target: self,
      action: #selector(didTapBackButton)
    )
    backButton.tintColor = .white
    backButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(backButton)

    backButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
    backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8).isActive = true
    backButton.accessibilityIdentifier = "nav back button white"
    self.backButton = backButton
  }

  private func setShareButton() {
    guard let buttonImage = UIImage(named: "shareButton") else { preconditionFailure("shareButton image doesn't exist") }
    let shareButton = UIButton(type: .custom)
    shareButton.setImage(buttonImage, for: .normal)
    shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    shareButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(shareButton)
    shareButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -69).isActive = true
    shareButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 711).isActive = true
    shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }

  private func updateMinZoomScaleForSize(_ size: CGSize) {
    let widthScale = size.width / imageView.bounds.width
    let heightScale = size.height / imageView.bounds.height
    let minScale = min(widthScale, heightScale)
    scrollView.minimumZoomScale = minScale
    scrollView.zoomScale = minScale
  }

  private func updateScrollViewForImage() {
    let minZoomScale = scrollView.minimumZoomScale
    let maxZoomScale = scrollView.maximumZoomScale
    let visibleRectSize = scrollView.bounds.size
    let imageSize = imageView.image?.size ?? .zero
    let hScale = visibleRectSize.width / imageSize.width
    let vScale = visibleRectSize.height / imageSize.height
    let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
    scrollView.setZoomScale(scale, animated: false)
    let x = (scrollView.contentSize.width - visibleRectSize.width) / 2
    let y = (scrollView.contentSize.height - visibleRectSize.height) / 2
    scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
  }
}

extension SingleImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
