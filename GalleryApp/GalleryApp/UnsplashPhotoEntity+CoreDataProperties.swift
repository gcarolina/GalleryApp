import Foundation
import CoreData

extension UnsplashPhotoEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnsplashPhotoEntity> {
        return NSFetchRequest<UnsplashPhotoEntity>(entityName: "UnsplashPhotoEntity")
    }
    
    @NSManaged public var altDescription: String?
    @NSManaged public var id: String?
    @NSManaged public var likedByUser: Bool
    @NSManaged public var regularURL: String?
    @NSManaged public var thumbURL: String?
}
