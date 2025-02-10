import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - Private Properties
    private var tableView: UITableView?
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
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
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
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

        configCell(for: ImagesListViewCell, with: indexPath)
        return ImagesListViewCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        let image = UIImage(named: photosName[indexPath.row])
        singleImageViewController.image = image
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width == 0 ? 1 : image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListViewCell, with indexPath: IndexPath) {
        cell.configCell(for: cell, with: indexPath)
    }
}
