import Foundation

protocol CoreDataManager {
    func isPhotoLiked(with id: String) -> Bool
    func saveFavoritePhoto(photo: UnsplashPhoto) throws
    func deleteFavoritePhoto(with id: String) throws
}
