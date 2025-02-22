struct AlertModel {
    // MARK: - Public Properties
    let title: String
    let message: String
    let buttonText: String
    let buttonText2: String?
    let completion: (() -> Void)
}
