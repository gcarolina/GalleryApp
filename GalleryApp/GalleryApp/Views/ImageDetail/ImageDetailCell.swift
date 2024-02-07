import UIKit
import Kingfisher

final class ImageDetailCell: UICollectionViewCell {
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.paleGrey
        label.font = .systemFont(ofSize: 23)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var favoriteImage: UIImage? = {
        UIImage(systemName: "heart.fill")
    }()
    
    lazy var unfavoriteImage: UIImage? = {
        UIImage(systemName: "heart")
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
            guard let photo = photo else { return }
            loadImage(from: photo.urls.regular)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }
    
    private func configureUI() {
        addSubview(image)
        addSubview(label)
        addSubview(likedButton)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -5),
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            likedButton.topAnchor.constraint(equalTo: image.topAnchor, constant: 10),
            likedButton.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -15),
            likedButton.widthAnchor.constraint(equalToConstant: 25),
            likedButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        likedButton.setBackgroundImage(unfavoriteImage, for: .normal)
        likedButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped() {
        likedButton.isSelected = !likedButton.isSelected
        likedButton.setBackgroundImage(likedButton.isSelected ? favoriteImage : unfavoriteImage, for: .normal)
    }
    
    private func setupShadow(for view: UIView) {
        view.layer.shadowColor = Colors.paleGrey.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
    }
    
    private func loadImage(from urlString: String) {
        self.label.text = self.photo?.altDescription
        
        guard let url = URL(string: urlString) else { return }
        image.kf.setImage(with: url, options: [.cacheOriginalImage]) { _ in
            self.image.layer.cornerRadius = 10
            self.image.layer.masksToBounds = true
            self.setupShadow(for: self)
        }
    }
}
