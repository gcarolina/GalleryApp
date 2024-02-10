import Foundation

struct UnsplashPhoto: Decodable {
    let id: String
    let altDescription: String?
    let urls: URLS
    var likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case altDescription = "alt_description"
        case urls
        case likedByUser = "liked_by_user"
    }
}
