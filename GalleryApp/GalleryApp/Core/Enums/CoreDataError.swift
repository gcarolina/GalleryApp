import Foundation

enum CoreDataError: Error {
    case fetchError(message: String)
    case saveError(message: String)
    case deleteError(message: String)
    
    var error: String {
        switch self {
        case .fetchError(let message),
             .saveError(let message),
             .deleteError(let message):
            return message
        }
    }
}
