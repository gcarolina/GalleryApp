import UIKit
import SkeletonView
import Kingfisher

final class ImageGalleryCell: UICollectionViewCell {
    private var animationPlayed = false
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var favoriteImage: UIImage? = {
        UIImage(systemName: "heart.fill")
    }()
    
    private let likedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.tintColor = Colors.redWine
        return button
    }()
    
    var photo: UnsplashPhoto? {
        didSet {
            guard let photo = photo else { return }
            loadImage(from: photo.urls.thumb)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !animationPlayed {
            setUpAnimation()
            animationPlayed = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.hideSkeleton()
        image.image = nil
    }
    
    private func configureUI() {
        likedButton.setBackgroundImage(favoriteImage, for: .normal)
        addSubview(image)
        addSubview(likedButton)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            likedButton.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -5),
            likedButton.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -10),
            likedButton.widthAnchor.constraint(equalToConstant: 25),
            likedButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8
        setupShadow(for: self)
    }
    
    private func setupShadow(for view: UIView) {
        view.layer.shadowColor = Colors.teal.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 12
        view.layer.masksToBounds = false
    }
    
    private func setUpAnimation() {
        image.isSkeletonable = true
        let gradient = SkeletonGradient(baseColor: Colors.paleGrey)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight,
                                                                        duration: 1.5)
        image.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .crossDissolve(0.25))
    }
    
    private func hideSkeleton() {
        image.hideSkeleton(transition: .crossDissolve(0.25))
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        image.kf.setImage(with: url, options: [.cacheOriginalImage]) { _ in
            self.animationPlayed = true
            self.hideSkeleton()
        }
    }
}
