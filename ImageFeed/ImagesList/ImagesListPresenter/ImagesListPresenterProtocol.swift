public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosName: [Photo] { get set }
    func viewDidLoad()
    func didPhotoUpdate()
    func updateLike(for photoNumber: Int?, cell: ImagesListViewCell?, _ completion: @escaping (Result<Bool , Error>) -> Void)
    func returnPhotosCount() -> Int
    func returnPhoto(by number: Int?) -> Photo?
    func loadNextPageIfNeeded(currentNumbers: Int?)
}
