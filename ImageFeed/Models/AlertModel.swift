struct AlertModel {
    // MARK: - Public Properties
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)
}
