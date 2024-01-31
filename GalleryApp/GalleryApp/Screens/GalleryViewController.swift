import UIKit
 
final class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private enum Constants {
        static let navigationItemTitle = "Eloquence Art Gallery"
        static let galleryCollectionViewCell = "GalleryCollectionViewCell"
    }
    
    private var collectionView: UICollectionView?
    private var collectionViewFlowLayout: UICollectionViewFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        } else {
            let gradientLayer = CAGradientLayer.gradientLayer(for: .greyToPurple, in: view.bounds)
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
        configureCollectionViewLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func configureUI() {
        navigationItem.title = Constants.navigationItemTitle
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewFlowLayout!)
        
        guard let collectionView = collectionView else { return }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: Constants.galleryCollectionViewCell)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureCollectionViewLayout() {
        guard let collectionView = collectionView, let layout = collectionViewFlowLayout else { return }
        
        let itemSpacing: CGFloat = 5
        
        if traitCollection.verticalSizeClass == .compact {
            let numberOfItemsInRow: CGFloat = 4
            let width = (collectionView.bounds.width - (itemSpacing * (numberOfItemsInRow - 1))) / numberOfItemsInRow
            layout.itemSize = CGSize(width: width, height: width)
        } else {
            let numberOfItemsInRow: CGFloat = 2
            let width = (collectionView.bounds.width - (itemSpacing * (numberOfItemsInRow - 1))) / numberOfItemsInRow
            layout.itemSize = CGSize(width: width, height: width)
        }
        
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Photos.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.galleryCollectionViewCell, for: indexPath) as? GalleryCollectionViewCell else {
            fatalError("The registered type for the cell does not match the casting")
        }
        cell.option = Photos.allCases[indexPath.row]
        return cell
    }
}
