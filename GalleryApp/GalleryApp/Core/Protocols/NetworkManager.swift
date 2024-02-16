import Foundation

protocol NetworkManager {
    func getPhotos(completion: @escaping (Result<[UnsplashPhoto], NetworkError>) -> Void)
}
