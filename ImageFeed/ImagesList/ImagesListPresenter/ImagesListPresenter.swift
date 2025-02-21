final class ImagesListPresenter: ImagesListPresenterProtocol {
    // MARK: - IB Outlets

    // MARK: - Public Properties
    var photosName: [Photo] = []
    weak var view: ImagesListViewControllerProtocol?
    // MARK: - Private Properties
    private var imagesListService: ImagesListServiceProtocol?
    // MARK: - Initializers
    func setImageListService(service: ImagesListServiceProtocol) {
        self.imagesListService = service
    }
    // MARK: - Overrides Methods

    // MARK: - IB Actions

    // MARK: - Public Methods
    func viewDidLoad() {
        setImageListService(service: ImagesListService.shared)
        imagesListService?.fetchPhotosNextPage()
    }
    
    func didPhotoUpdate() {
        guard let service = imagesListService else {
            print("service is nil")
            return
        }
        let oldCount = photosName.count
        let newCount = service.photos.count
        photosName = service.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(from: oldCount, to: newCount)
        }
    }
    
    func updateLike(for photoNumber: Int?, cell: ImagesListViewCell?, _ completion: @escaping (Result<Bool , Error>) -> Void) {
        guard let photoNumber else {
            print("IndexPath is nil")
            return
        }
        guard let cell else {
            print("cell is nil")
            return
        }
        guard let service = imagesListService else {
            print("service is nil")
            return
        }
        let photo = photosName[photoNumber]
        service.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] response in
            guard let self else { preconditionFailure("self doesn't exist")}
            switch response {
            case.success(let currentLike):
                self.photosName[photoNumber].isLiked = currentLike
                cell.refreshLikeImage(to: currentLike)
                completion(.success(true))
            case.failure(let error):
                print("error - \(error)")
                completion(.failure(error))
            }
        }
    }
    func returnPhotosCount() -> Int {
        photosName.count
    }
    func returnPhoto(by number: Int?) -> Photo? {
        guard let number else {
            print("number is nil")
            return nil
        }
        return photosName[number]
    }
    func loadNextPageIfNeeded(currentNumbers: Int?) {
        guard currentNumbers == photosName.count - 1 else {return}
        guard let service = imagesListService else {
            print("service is nil")
            return
        }
        service.fetchPhotosNextPage()
    }
    // MARK: - Private Methods
}
