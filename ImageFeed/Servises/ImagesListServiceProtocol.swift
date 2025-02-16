public protocol ImagesListServiceProtocol {
    var photos: [Photo] { get set }
    func sentNotification()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool , Error>) -> Void)
}
