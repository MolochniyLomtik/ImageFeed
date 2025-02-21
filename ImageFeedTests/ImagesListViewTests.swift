import XCTest
import ImageFeed
import Foundation
@testable import ImageFeed

final class ImagesListViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        _ = viewController.view
        //then
        XCTAssert(presenter.viewDidLoadCalled) // behavior verification
    }
    
    func testNotification() {
        //given
        let imagesListService = ImagesListService.shared
        let _ = expectation(forNotification: ImagesListService.didChangeNotification, object: imagesListService, handler: nil)
        //when
        imagesListService.sentNotification()
        //then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testViewControllerCallsDidPhotoUpdate() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        let imagesListService = ImagesListService.shared
        viewController.setupPresenter(presenter)
        viewController.addImagesListServiceObserver()
        //when
        imagesListService.sentNotification()
        //then
        XCTAssert(presenter.didPhotoUpdateCalled) // behavior verification
    }
    
    func testViewControllerCallsUpdateLike() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        let cellStub = ImagesListViewCell()
        viewController.setupPresenter(presenter)
        //when
        viewController.imageListCellDidTapLike(for: cellStub)
        //then
        XCTAssert(presenter.updateLikeCalled) // behavior verification
    }
    
    func testViewControllerCallsReturnPhotosCount() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        let tableViewStub = UITableView()
        viewController.setupPresenter(presenter)
        //when
        let _ = viewController.tableView(tableViewStub, numberOfRowsInSection: 10)
        //then
        XCTAssert(presenter.returnPhotosCountCalled) // behavior verification
    }
    
    func testViewControllerCallsReturnPhoto() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        let tableViewStub = UITableView()
        let indexPathStub = IndexPath()
        viewController.setupPresenter(presenter)
        //when
        let _ = viewController.tableView(tableViewStub, didSelectRowAt: indexPathStub)
        //then
        XCTAssert(presenter.returnPhotoCalled) // behavior verification
    }
    
    func testViewControllerCallsLoadNextPageIfNeeded() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        let tableViewStub = UITableView()
        let cellStub = UITableViewCell()
        let indexPathStub = IndexPath()
        viewController.setupPresenter(presenter)
        //when
        let _ = viewController.tableView(tableViewStub, willDisplay: cellStub, forRowAt: indexPathStub)
        //then
        XCTAssert(presenter.loadNextPageIfNeededCalled) // behavior verification
    }
    
    func testViewControllerSetupPresenter() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenter()
        //when
        viewController.setupPresenter(presenter)
        //then
        XCTAssert(viewController.presenter != nil)
    }
    
    func testPresenterCallsUpdateTableViewAnimated() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        let imagesListServiceStub = ImagesListServiceStub.shared
        viewController.setupPresenter(presenter)
        presenter.setImageListService(service: imagesListServiceStub)
        //when
        presenter.didPhotoUpdate()
        //then
        XCTAssert(viewController.updateTableViewAnimatedCalled)
    }
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photosName: [Photo] = []
    
    var viewDidLoadCalled = false
    var didPhotoUpdateCalled = false
    var updateLikeCalled = false
    var returnPhotosCountCalled = false
    var returnPhotoCalled = false
    var loadNextPageIfNeededCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didPhotoUpdate() {
        didPhotoUpdateCalled = true
    }
    
    func updateLike(for photoNumber: Int?, cell: ImagesListViewCell?, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        updateLikeCalled = true
    }
    
    func returnPhotosCount() -> Int {
        returnPhotosCountCalled = true
        return 0
    }
    
    func returnPhoto(by number: Int?) -> Photo? {
        returnPhotoCalled = true
        return nil
    }
    
    func loadNextPageIfNeeded(currentNumbers: Int?) {
        loadNextPageIfNeededCalled = true
    }
    
 
}

final class ImagesListViewControllerSpy : ImagesListViewControllerProtocol {
    var presenter: (any ImageFeed.ImagesListPresenterProtocol)?
    var updateTableViewAnimatedCalled = false
    var addImagesListServiceObserverCalled = false
    
    func setupPresenter(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateTableViewAnimated(from oldCount: Int, to newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
    
    func addImagesListServiceObserver() {
        addImagesListServiceObserverCalled = true
    }
    
}

final class ImagesListServiceStub: ImagesListServiceProtocol {
    static let shared = ImagesListServiceStub()
    var photos: [Photo] = [Photo(id: "", size: CGSize(width: 0, height: 0), createdAt: nil, welcomeDescription: nil, thumbImageURL: nil, largeImageURL: nil, isLiked: false)]
    
    private init() { }
    
    func sentNotification() {
        
    }
    func fetchPhotosNextPage() {
        
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        
    }
}

