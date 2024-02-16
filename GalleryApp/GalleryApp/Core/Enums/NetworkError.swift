import Foundation

enum NetworkError: Error {
    case urlCreationFailure(description: String)
    case requestFailed(description: String)
    
    var error: String {
        switch self {
        case .urlCreationFailure(let description),
                .requestFailed(let description):
            return description
        }
    }
}
