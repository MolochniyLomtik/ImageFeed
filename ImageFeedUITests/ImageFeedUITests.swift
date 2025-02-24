import XCTest

class Image_FeedUITests: XCTestCase {

  private enum PersonalData {
    static let email = "test.1@mail.ru"
    static let password = "12345678Aa"
    static let fullName = "test test"
    static let login = "@testerthebester212"
  }

  private let app = XCUIApplication() // переменная приложения

  override func setUpWithError() throws {
    continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
    app.launchEnvironment["isUITest"] = "true"
    app.launch() // запускаем приложение перед каждым тестом

  }

  func testAuth() throws {
    // тестируем сценарий авторизации
    app.buttons["Authenticate"].tap()

    let webView = app.webViews["UnsplashWebView"]
    XCTAssertTrue(webView.waitForExistence(timeout: 10))


    let loginTextField = webView.descendants(matching: .textField).element
    XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
    loginTextField.tap()
    XCTAssertTrue(loginTextField.waitForExistence(timeout: 2))
    loginTextField.typeText(PersonalData.email)

    let passwordTextField = webView.descendants(matching: .secureTextField).element
    XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
    app.launchArguments.append(contentsOf: ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"])
    passwordTextField.tap()
    XCTAssertTrue(passwordTextField.waitForExistence(timeout: 2))
    passwordTextField.typeText(PersonalData.password)

    webView.buttons["Login"].tap()

    let tablesQuery = app.tables
    let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

    XCTAssertTrue(cell.waitForExistence(timeout: 5))
  }

  func testFeed() throws {
    let tablesQuery = app.tables

    let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
    cell.swipeUp()

    sleep(2)

    let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)

    cellToLike.buttons["like button"].tap()
    sleep(2)
    cellToLike.buttons["like button"].tap()

    sleep(2)

    cellToLike.tap()

    sleep(2)

    let image = app.scrollViews.images.element(boundBy: 0)

    image.pinch(withScale: 3, velocity: 1) // zoom in

    image.pinch(withScale: 0.5, velocity: -1)

    let navBackButtonWhiteButton = app.buttons["nav back button white"]
    navBackButtonWhiteButton.tap()
  }

  func testProfile() throws {
    sleep(3)
    app.tabBars.buttons.element(boundBy: 1).tap()

    XCTAssertTrue(app.staticTexts[PersonalData.fullName].exists)
    XCTAssertTrue(app.staticTexts[PersonalData.login].exists)

    app.buttons["logout button"].tap()

    app.alerts["Пока Пока!"].scrollViews.otherElements.buttons["Да"].tap()

    XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
  }
}
