import UIKit

enum Photos: String, CaseIterable {
    case logo
    case photo1
    case photo2
    case photo3
    case photo4
}

final class GalleryCollectionViewCell: UICollectionViewCell {
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var likedImage: UIImage? {
        let image = UIImage(systemName: "heart.fill")
        return image
    }
    
    private let likedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.tintColor = Colors.redWine
        return button
    }()
    
    var option: Photos? {
        didSet {
            guard let option = option else { return }
            image.image = UIImage(named: option.rawValue)
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
        likedButton.setBackgroundImage(likedImage, for: .normal)
        addSubview(image)
        addSubview(likedButton)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            likedButton.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -5),
            likedButton.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -5),
            likedButton.widthAnchor.constraint(equalToConstant: 25),
            likedButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8
        setupShadow(for: self)
    }
    
    private func setupShadow(for view: UIView) {
        view.layer.shadowColor = Colors.royalPurple.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 7
        view.layer.masksToBounds = false
    }
}
