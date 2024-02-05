import Foundation

enum NetworkError: Error {
    case failedToFetchPhotos(message: String)

    var error: String {
        switch self {
        case .failedToFetchPhotos(let message):
            return message
        }
    }
}

final class GalleryViewModel {
    var photos: [UnsplashPhoto] = []
    
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchPhotos(completion: @escaping (Error?) -> Void) {
        networkManager.getPhotos { [weak self] fetchedPhotos in
            guard let self = self else { return }
            
            if let fetchedPhotos = fetchedPhotos {
                self.photos.append(contentsOf: fetchedPhotos)
                completion(nil)
            } else {
                let error = NetworkError.failedToFetchPhotos(message: "Failed to fetch photos.")
                completion(error)
            }
        }
    }
}
