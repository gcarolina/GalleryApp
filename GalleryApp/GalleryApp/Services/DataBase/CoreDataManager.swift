import UIKit

final class CoreDataManager {
    
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func getImages() -> [UnsplashPhotoEntity] {
        do {
            let images = try context.fetch(UnsplashPhotoEntity.fetchRequest())
            return images
        } catch {
            return []
        }
    }
    
    static func saveImageToCoreData(_ photo: UnsplashPhoto?) {
        guard let photo = photo else { return }
        
        let likedPhoto = UnsplashPhotoEntity(context: context)
        likedPhoto.id = photo.id
        likedPhoto.altDescription = photo.altDescription
        likedPhoto.likedByUser = photo.likedByUser
        likedPhoto.regularURL = photo.urls.regular
        likedPhoto.thumbURL = photo.urls.thumb
       
        do {
            try context.save()
        } catch {
            // error
        }
        
    }
    
    static func deleteImageFromCoreData(_ photo: UnsplashPhotoEntity?) {
        guard let photo = photo else { return }
        
        context.delete(photo)
        
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
}
