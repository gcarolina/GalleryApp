import Foundation

protocol NetworkManager {
    func getPhotos(completion: @escaping ([UnsplashPhoto]?) -> Void)
}
