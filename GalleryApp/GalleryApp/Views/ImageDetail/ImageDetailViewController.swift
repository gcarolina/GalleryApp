import UIKit
import Combine

final class ImageDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private enum Constants {
        static let imageDetailCell = "ImageDetailCell"
        static let decrement: CGFloat = 1
        static let section = 0
    }
    
    private enum LayoutConstants {
        static let gradientLayerPosition: UInt32 = 0
        static let itemSpacing: CGFloat = 10
        static let numberOfItemsInCompactRow: CGFloat = 2
        static let numberOfItemsInRegularRow: CGFloat = 1
    }
    
    private var collectionView: UICollectionView?
    private var collectionViewFlowLayout: UICollectionViewFlowLayout?
    
    private var cancellables: Set<AnyCancellable> = []
    var imageDetailViewModel: ImageDetailViewModel?
    private var coreDataManager: CoreDataManager

    init(imageDetailViewModel: ImageDetailViewModel, coreDataManager: CoreDataManager) {
        self.imageDetailViewModel = imageDetailViewModel
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureUI()
    }
    
    private func bindViewModel() {
        imageDetailViewModel?.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView?.reloadData()
                self?.collectionView?.layoutIfNeeded()
                
                if let initialIndex = self?.imageDetailViewModel?.initialPhotoIndex {
                    self?.collectionView?.scrollToItem(at: IndexPath(item: initialIndex, section: Constants.section),
                                                       at: .centeredHorizontally, animated: false)
                }
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        } else {
            let gradientLayer = CAGradientLayer.gradientLayer(for: .greyToTeal, in: view.bounds)
            view.layer.insertSublayer(gradientLayer, at: LayoutConstants.gradientLayerPosition)
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
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        guard let collectionViewFlowLayout = collectionViewFlowLayout else { return }
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewFlowLayout)
        
        guard let collectionView = collectionView else { return }
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(ImageDetailCell.self, forCellWithReuseIdentifier: Constants.imageDetailCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    private func configureCollectionViewLayout() {
        guard let collectionView = collectionView, let layout = collectionViewFlowLayout else { return }

        let numberOfItemsInRow: CGFloat

        if traitCollection.verticalSizeClass == .compact {
            numberOfItemsInRow = LayoutConstants.numberOfItemsInCompactRow
        } else {
            numberOfItemsInRow = LayoutConstants.numberOfItemsInRegularRow
        }
        
        let height = collectionView.bounds.height
        let width = (collectionView.bounds.width - (LayoutConstants.itemSpacing * (numberOfItemsInRow - Constants.decrement))) / numberOfItemsInRow
        layout.itemSize = CGSize(width: width, height: height)

        layout.minimumInteritemSpacing = LayoutConstants.itemSpacing
        layout.minimumLineSpacing = LayoutConstants.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageDetailViewModel?.photos.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageDetailCell,
                                                            for: indexPath) as? ImageDetailCell else {
            fatalError("The registered type for the cell does not match the casting")
        }
        cell.photo = imageDetailViewModel?.photos[indexPath.item]
        cell.coreDataManager = self.coreDataManager
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
