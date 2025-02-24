import Foundation
import UIKit


public final class ImagesListViewCell: UITableViewCell {
    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    // MARK: - Private Properties
    private lazy var imageCellView = UIImageView()
    private lazy var likeButton = UIButton()
    private lazy var dateLabel = UILabel()
    private lazy var gradientView = UIView()
    private let isoDateFormatter = ISO8601DateFormatter()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    // MARK: - Overrides Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCellUI()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageCellView.kf.cancelDownloadTask()
        imageCellView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - IB Actions
    @objc
    private func didTapLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(for: self)
    }
    // MARK: - Public Methods
    func refreshLikeImage(to isLike: Bool) {
        likeButton.setImage(isLike ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off"), for: .normal)
    }
    func configCell(from photo: Photo){
        imageCellView.kf.setImage(with: photo.thumbImageURL, placeholder: UIImage(named: "cellPlaceHolder"))
        imageCellView.kf.indicatorType = .activity
        if let photoDate = photo.createdAt, let date = isoDateFormatter.date(from: photoDate) {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
        likeButton.imageView?.image = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
    }
    // MARK: - Private Methods
    private func setCellUI() {
        setImageCellView()
        setLikeButton()
        setDateLabel()
        setGradient()
    }
    
    private func setImageCellView() {
        self.contentView.addSubview(self.imageCellView)
        self.imageCellView.contentMode = .scaleAspectFill
        self.imageCellView.layer.cornerRadius = 16
        self.imageCellView.layer.masksToBounds = true
        self.contentView.backgroundColor = .ypBlack
        self.backgroundColor = .ypBlack
        self.selectionStyle = .none
        self.imageCellView.translatesAutoresizingMaskIntoConstraints = false
        self.imageCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        self.imageCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        self.imageCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        self.imageCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
    }
    
    private func setLikeButton() {
        guard let likeImage = UIImage(named: "like_button_off") else {return}
        let likeButton = UIButton(type: .custom)
        likeButton.setImage(likeImage, for: .normal)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        likeButton.accessibilityIdentifier = "like button"
        self.likeButton = likeButton
        self.contentView.addSubview(self.likeButton)
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4).isActive = true
        self.likeButton.trailingAnchor.constraint(equalTo:  self.contentView.trailingAnchor, constant: -16).isActive = true
        self.likeButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        self.likeButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
    }
    
    private func setDateLabel() {
        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.textColor = .white
        self.dateLabel.font = .systemFont(ofSize: 13)
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24).isActive = true
        self.dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12).isActive = true
    }
    
    private func setGradient() {
        self.contentView.addSubview(self.gradientView)
        self.gradientView.layer.masksToBounds = true
        self.gradientView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.gradientView.layer.cornerRadius = 16
        self.gradientView.translatesAutoresizingMaskIntoConstraints = false
        self.gradientView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16).isActive = true
        self.gradientView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
        self.gradientView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4).isActive = true
        self.gradientView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.gradientView.layoutIfNeeded()
        let gradientViewLayer = CAGradientLayer()
        gradientViewLayer.colors = [UIColor.ypBlack0.cgColor, UIColor.ypBlack20.cgColor]
        gradientViewLayer.frame = self.gradientView.bounds
        if self.gradientView.layer.sublayers?.count == nil  {
            self.gradientView.layer.addSublayer(gradientViewLayer)
        }
    }
}

