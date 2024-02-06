import UIKit
import Combine

final class ImageGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private enum Constants {
        static let navigationItemTitle = "Eloquence Art Gallery"
        static let imageGalleryCell = "ImageGalleryCell"
        static let decrement = 1
    }
    
    private enum LayoutConstants {
        static let itemSpacing: CGFloat = 2
        static let numberOfItemsInCompactRow: CGFloat = 4
        static let numberOfItemsInRegularRow: CGFloat = 2
    }
    
    private var collectionView: UICollectionView?
    private var collectionViewFlowLayout: UICollectionViewFlowLayout?
    
    private let networkManager: NetworkManager
    private var galleryViewModel: ImageGalleryViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.galleryViewModel = ImageGalleryViewModel(networkManager: networkManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        galleryViewModel.fetchPhotos()
    }
    
    private func bindViewModel() {
        galleryViewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView?.reloadData()
            }
            .store(in: &cancellables)
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
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewFlowLayout!)
        
        guard let collectionView = collectionView else { return }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageGalleryCell.self, forCellWithReuseIdentifier: Constants.imageGalleryCell)
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
        
        if traitCollection.verticalSizeClass == .compact {
            let width = (collectionView.bounds.width - (LayoutConstants.itemSpacing * (LayoutConstants.numberOfItemsInCompactRow - 1))) / LayoutConstants.numberOfItemsInCompactRow
            layout.itemSize = CGSize(width: width, height: width)
        } else {
            let width = (collectionView.bounds.width - (LayoutConstants.itemSpacing * (LayoutConstants.numberOfItemsInRegularRow - 1))) / LayoutConstants.numberOfItemsInRegularRow
            layout.itemSize = CGSize(width: width, height: width)
        }
        
        layout.minimumInteritemSpacing = LayoutConstants.itemSpacing
        layout.minimumLineSpacing = LayoutConstants.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        galleryViewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageGalleryCell,
                                                            for: indexPath) as? ImageGalleryCell else {
            fatalError("The registered type for the cell does not match the casting")
        }
        cell.photo = galleryViewModel.photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageDetailViewModel = ImageDetailViewModel()
        imageDetailViewModel.photos = self.galleryViewModel.photos

        let imageDetailVC = ImageDetailViewController()
        imageDetailVC.imageDetailViewModel = imageDetailViewModel
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSection = collectionView.numberOfSections - Constants.decrement
        let lastItemInSection = collectionView.numberOfItems(inSection: lastSection) - Constants.decrement
        
        if indexPath.section == lastSection && indexPath.item == lastItemInSection {
            galleryViewModel.fetchPhotos()
        }
    }
}
