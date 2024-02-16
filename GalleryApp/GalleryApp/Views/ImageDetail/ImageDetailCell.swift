import UIKit

final class ImageDetailCell: UICollectionViewCell {
    private enum ImageDetailConstants {
        static let fontSize: CGFloat = 23
        static let numberOfLines = 0
        static let favoriteImageName = "heart.fill"
        static let unfavoriteImage = "heart"
        static let duration = 1.5
        static let transition = 0.25
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.paleGrey
        label.font = .systemFont(ofSize: ImageDetailConstants.fontSize)
        label.numberOfLines = ImageDetailConstants.numberOfLines
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = Colors.teal
        return indicator
    }()
    
    private lazy var favoriteImage: UIImage? = {
        UIImage(systemName: ImageDetailConstants.favoriteImageName)
    }()
    
    private lazy var unfavoriteImage: UIImage? = {
        UIImage(systemName: ImageDetailConstants.unfavoriteImage)
    }()
    
    private let likedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Colors.redWine
        return button
    }()
    
    var viewModel: ImageDetailCellViewModel? {
        didSet {
            configureCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
        likedButton.isSelected = false
    }
    
    private func configureUI() {
        addSubview(imageView)
        addSubview(label)
        addSubview(likedButton)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -5),
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            likedButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 10),
            likedButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -15),
            likedButton.widthAnchor.constraint(equalToConstant: 25),
            likedButton.heightAnchor.constraint(equalToConstant: 25),
            
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        likedButton.addTarget(self, action: #selector(toggleLikeButtonState), for: .touchUpInside)
    }
    
    @objc private func toggleLikeButtonState() {
        likedButton.isSelected = !likedButton.isSelected
        likedButton.setBackgroundImage(likedButton.isSelected ? favoriteImage : unfavoriteImage, for: .normal)
        
        guard let viewModel = viewModel else { return }
        if likedButton.isSelected {
            viewModel.savePhotoToFavorites()
        } else {
            viewModel.deletePhotoFromFavorites()
        }
    }
    
    private func configureCell() {
        guard let viewModel = viewModel else { return }
        likedButton.isSelected = viewModel.isPhotoLiked()
        likedButton.setBackgroundImage(likedButton.isSelected ? favoriteImage : unfavoriteImage, for: .normal)
        
        activityIndicator.startAnimating()
        viewModel.loadImage { [weak self] image in
            self?.activityIndicator.stopAnimating()
            self?.imageView.image = image
            self?.imageView.layer.cornerRadius = 10
            self?.imageView.layer.masksToBounds = true
            self?.setupShadow()
        }
        label.text = viewModel.photo?.altDescription
    }
}
