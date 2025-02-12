import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ImagesListCellDelegate {
    // MARK: - Private Properties
    private var tableView: UITableView?
    private var photosName: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    // MARK: - Overrides Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        addImagesListServiceObserver()
        imagesListService.fetchPhotosNextPage()
    }
    
    // MARK: - Private Methods
    private func setTableView() {
        view.backgroundColor = .ypBlack
        let tableView = UITableView()
        tableView.register(ImagesListViewCell.self, forCellReuseIdentifier: ImagesListViewCell.reuseIdentifier)
        tableView.backgroundColor = .ypBlack
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        self.tableView = tableView
    }
    
    private func addImagesListServiceObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self = self else { return }
                    self.updateTableViewAnimated()
                }
            )
    }
    
    private func updateTableViewAnimated() {
        guard let tableView else {
            preconditionFailure("table view doesn't exist")
        }
        let oldCount = photosName.count
        let newCount = imagesListService.photos.count
        photosName = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func setIsLiked(for cell: ImagesListViewCell) {
        guard let tableView else { preconditionFailure("tableView doesn't exist") }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photosName[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] response in
            guard let self else { preconditionFailure("self doesn't exist")}
            switch response {
            case.success(let currentLike):
                self.photosName[indexPath.row].isLiked = currentLike
                cell.refreshLikeImage(to: currentLike)
                UIBlockingProgressHUD.dismiss()
            case.failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Cant refresh like condition \(error)")
            }
        }
    }
    
    // MARK: - Public Methods
    func imageListCellDidTapLike(_ cell: ImagesListViewCell) {
        setIsLiked(for: cell)
    }
    
}

// MARK: - Extensions
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListViewCell.reuseIdentifier, for: indexPath)
        
        guard let ImagesListViewCell = cell as? ImagesListViewCell else {
            return UITableViewCell()
        }

        configCell(for: ImagesListViewCell, with: indexPath, from: photosName)
        ImagesListViewCell.delegate = self
        return ImagesListViewCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        let image = photosName[indexPath.row]
        singleImageViewController.image = image
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photosName[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width == 0 ? 1 : image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListViewCell, with indexPath: IndexPath, from data: [Photo]) {
        cell.configCell(for: cell, with: indexPath, from: data)
        guard let tableView else {return}
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ImagesListViewController {
    func tableView( _ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == photosName.count - 1 else {return}
        imagesListService.fetchPhotosNextPage()
    }
}
