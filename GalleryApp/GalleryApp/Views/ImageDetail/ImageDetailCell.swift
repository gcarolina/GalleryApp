import UIKit
import AlamofireImage

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
    
    lazy var favoriteImage: UIImage? = {
        UIImage(systemName: ImageDetailConstants.favoriteImageName)
    }()
    
    lazy var unfavoriteImage: UIImage? = {
        UIImage(systemName: ImageDetailConstants.unfavoriteImage)
    }()
    
    private let likedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Colors.redWine
        return button
    }()
    
    var photo: UnsplashPhoto? {
        didSet {
            configureCell()
        }
    }
    
    var coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(frame: .zero)
        configureUI()
    }
    
    override init(frame: CGRect) {
        self.coreDataManager = FavoritePhotoCoreDataManager()
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
        
        if let photo = photo {
            if likedButton.isSelected {
                try? coreDataManager.saveFavoritePhoto(photo: photo)
            } else {
                try? coreDataManager.deleteFavoritePhoto(with: photo.id)
            }
        }
    }
    
    private func setupShadow(for view: UIView) {
        view.layer.shadowColor = Colors.paleGrey.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
    }
    
    private func configureCell() {
        guard let photo = photo else { return }
        likedButton.isSelected = coreDataManager.isPhotoLiked(with: photo.id)
        likedButton.setBackgroundImage(likedButton.isSelected ? favoriteImage : unfavoriteImage, for: .normal)
        
        guard let imageURL = URL(string: photo.urls.regular) else { return }
        activityIndicator.startAnimating()
        
        imageView.af.setImage(withURL: imageURL, completion: { response in
            self.activityIndicator.stopAnimating()
            switch response.result {
            case .success:
                self.imageView.layer.cornerRadius = 10
                self.imageView.layer.masksToBounds = true
                self.setupShadow(for: self)
            case .failure:
                break
            }
        })
        
        label.text = photo.altDescription
    }
}
