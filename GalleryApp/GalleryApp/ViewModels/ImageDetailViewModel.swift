import Foundation
import Combine

final class ImageDetailViewModel: ObservableObject {
    @Published var photos: [UnsplashPhoto] = []
}
