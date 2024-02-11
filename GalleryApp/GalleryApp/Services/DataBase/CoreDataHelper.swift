import UIKit
import CoreData

final class CoreDataHelper: CoreDataManager {
    private enum Constants {
        static let format = "id == %@"
        static let entityName = "UnsplashPhotoEntity"
        
        static let messageForFetchingError = "Error fetching photo entity"
        static let messageForSavingPhotoError = "Error saving favorite photo"
        static let messageForDeletingPhotoError = "Error deleting favorite photo"
    }
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func isPhotoLiked(with id: String) -> Bool {
        return (try? fetchPhotoEntity(with: id)) != nil
    }
    
    private func fetchPhotoEntity(with id: String?) throws -> UnsplashPhotoEntity? {
        guard let id = id else { return nil }
        let fetchRequest: NSFetchRequest<UnsplashPhotoEntity> = UnsplashPhotoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: Constants.format, id)
        do {
            return try context?.fetch(fetchRequest).first
        } catch {
            throw CoreDataError.fetchError(message: Constants.messageForFetchingError + "\(error)")
        }
    }
    
    func saveFavoritePhoto(photo: UnsplashPhoto) throws {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: Constants.entityName, in: context) else { return }
        createPhotoEntity(entity: entity, photo: photo)
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveError(message: Constants.messageForSavingPhotoError + "\(error)")
        }
    }
    
    private func createPhotoEntity(entity: NSEntityDescription, photo: UnsplashPhoto) {
        let photoEntity = UnsplashPhotoEntity(entity: entity, insertInto: context)
        photoEntity.id = photo.id
        photoEntity.altDescription = photo.altDescription
        photoEntity.regularURL = photo.urls.regular
        photoEntity.thumbURL = photo.urls.thumb
        photoEntity.likedByUser = true
    }
    
    func deleteFavoritePhoto(with id: String) throws {
        guard let context = context else { return }
        do {
            if let photoEntity = try fetchPhotoEntity(with: id) {
                context.delete(photoEntity)
                try? context.save()
            }
        } catch {
            throw CoreDataError.saveError(message: Constants.messageForSavingPhotoError + "\(error)")
        }
    }
}
