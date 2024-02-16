import UIKit
import SkeletonView

final class ImageGalleryCell: UICollectionViewCell {
    private enum ImageGalleryConstants {
        static let favoriteImageName = "heart.fill"
        static let duration = 1.5
        static let transition = 0.25
    }
    private var animationPlayed = false
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var favoriteImage: UIImage? = {
        UIImage(systemName: ImageGalleryConstants.favoriteImageName)
    }()
    
    private let likedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.tintColor = Colors.redWine
        return button
    }()
    
    var viewModel: ImageGalleryCellViewModel? {
        didSet {
            configureCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        imageView.hideSkeleton()
        imageView.image = nil
    }
    
    private func configureUI() {
        addSubview(imageView)
        addSubview(likedButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            likedButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5),
            likedButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            likedButton.widthAnchor.constraint(equalToConstant: 25),
            likedButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isSkeletonable = true
        self.setupShadow()
    }
    
    private func setUpAnimation() {
        let gradient = SkeletonGradient(baseColor: Colors.paleGrey)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight,
                                                                        duration: ImageGalleryConstants.duration)
        imageView.showAnimatedGradientSkeleton(usingGradient: gradient,
                                               animation: animation,
                                               transition: .crossDissolve(ImageGalleryConstants.transition))
    }
    
    private func hideSkeleton() {
        imageView.hideSkeleton(transition: .crossDissolve(ImageGalleryConstants.transition))
    }
    
    private func configureCell() {
        guard let viewModel = viewModel else { return }
        viewModel.loadImage { [weak self] image in
            self?.imageView.image = image
            self?.animationPlayed = true
            self?.hideSkeleton()
        }
        likedButton.setBackgroundImage(viewModel.isPhotoLiked() ? favoriteImage : nil, for: .normal)
    }
}
