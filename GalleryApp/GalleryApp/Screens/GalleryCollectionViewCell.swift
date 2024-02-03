import UIKit

final class GalleryCollectionViewCell: UICollectionViewCell {
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
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
    
    var option: URLS? {
        didSet {
            guard let option = option else { return }
            loadImage(from: option.thumb)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
    
    private func configureUI() {
        likedButton.setBackgroundImage(likedImage, for: .normal)
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
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.image.image = UIImage(data: data)
            }
        }.resume()
    }
}
