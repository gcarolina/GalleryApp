import UIKit
import Alamofire

final class ImageGalleryCellViewModel {
    var photo: UnsplashPhoto?
    
    private var coreDataManager: CoreDataManager
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let photo = photo else {
            completion(nil)
            return
        }
        
        let urlString = photo.urls.thumb
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        AF.request(url).response { response in
            if let data = response.data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    func isPhotoLiked() -> Bool {
        guard let photo = photo else { return false }
        return coreDataManager.isPhotoLiked(with: photo.id)
    }
}
