import Foundation
import Combine

final class GalleryViewModel: ObservableObject {
    @Published var photos: [UnsplashPhoto] = []
    
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchPhotos() {
        networkManager.getPhotos { [weak self] fetchedPhotos in
            guard let self = self else { return }
            guard let fetchedPhotos = fetchedPhotos else { return }
            self.photos.append(contentsOf: fetchedPhotos)
        }
    }
}
