import Foundation

protocol CoreDataManager {
    func isPhotoLiked(with id: String) -> Bool
    func saveFavoritePhoto(photo: UnsplashPhoto)
    func deleteFavoritePhoto(with id: String)
}
