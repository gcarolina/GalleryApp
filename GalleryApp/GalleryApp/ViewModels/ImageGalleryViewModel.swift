import Foundation
import Combine

final class ImageGalleryViewModel: ObservableObject {
    private enum Constants {
        static let fetchingError = "Error fetching photos"
    }
    
    @Published var photos: [UnsplashPhoto] = []
    
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchPhotos() {
        networkManager.getPhotos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedPhotos):
                self.photos.append(contentsOf: fetchedPhotos)
            case .failure(let error):
                print(Constants.fetchingError + "\(error)")
            }
        }
    }
}
