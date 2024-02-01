import Foundation

struct UnsplashPhoto: Decodable {
    let id: String
    let altDescription: String
    let urls: URLS
    var likes: Int
    var likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case altDescription = "alt_description"
        case urls
        case likes
        case likedByUser = "liked_by_user"
    }
}
