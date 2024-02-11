import UIKit
import CoreData

final class CoreDataManager {
    static func isPhotoLiked(with id: String) -> Bool {
        return fetchPhotoEntity(with: id) != nil
    }
    
    static func fetchPhotoEntity(with id: String?) -> UnsplashPhotoEntity? {
        guard let id = id else { return nil }
        
        let fetchRequest: NSFetchRequest<UnsplashPhotoEntity> = UnsplashPhotoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let result = try (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.fetch(fetchRequest)
            return result?.first
        } catch {
            print("Error fetching photo entity: \(error)")
            return nil
        }
    }
    
    static func saveFavoritePhoto(photo: UnsplashPhoto) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

        guard let entity = NSEntityDescription.entity(forEntityName: "UnsplashPhotoEntity", in: context!) else { return }

        let photoEntity = UnsplashPhotoEntity(entity: entity, insertInto: context)
        photoEntity.id = photo.id
        photoEntity.altDescription = photo.altDescription
        photoEntity.regularURL = photo.urls.regular
        photoEntity.thumbURL = photo.urls.thumb
        photoEntity.likedByUser = true
        
        do {
            try context?.save()
        } catch {
            print("Error saving favorite photo: \(error)")
        }
    }

    static func deleteFavoritePhoto(with id: String) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

        if let photoEntity = fetchPhotoEntity(with: id) {
            context?.delete(photoEntity)
            do {
                try context?.save()
            } catch {
                print("Error deleting favorite photo: \(error)")
            }
        }
    }
}
