import UIKit

final class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private enum Constants {
        static let navigationItemTitle = "Eloquence Art Gallery"
        static let galleryCell = "GalleryCell"
    }
    
    private var collectionView: UICollectionView?
    private var collectionViewFlowLayout: UICollectionViewFlowLayout?
    
    private var photos: [UnsplashPhoto] = []
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPhotos()
    }
    
    private func fetchPhotos() {
        networkManager.getPhotos { [weak self] fetchedPhotos in
            guard let self = self else { return }
            
            if let fetchedPhotos = fetchedPhotos {
                self.photos.append(contentsOf: fetchedPhotos)
                self.collectionView?.reloadData()
            } else {
                print("Error fetching photos")
            }
        }
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
            let gradientLayer = CAGradientLayer.gradientLayer(for: .greyToTeal, in: view.bounds)
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
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: Constants.galleryCell)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureCollectionViewLayout() {
        guard let collectionView = collectionView, let layout = collectionViewFlowLayout else { return }
        
        let itemSpacing: CGFloat = 2
        
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
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.galleryCell,
                                                            for: indexPath) as? GalleryCell else {
            fatalError("The registered type for the cell does not match the casting")
        }
        cell.photo = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSection = collectionView.numberOfSections - 1
        let lastItemInSection = collectionView.numberOfItems(inSection: lastSection) - 1
        
        if indexPath.section == lastSection && indexPath.item == lastItemInSection {
            fetchPhotos()
        }
    }
}
