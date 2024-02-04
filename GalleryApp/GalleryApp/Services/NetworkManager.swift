import Foundation

private enum NetworkSettings {
    enum APIKey: String {
        case authorization = "Authorization"
        case accessKey = "Client-ID pYHOpi9VcOXwSkCJCxtIar_yaWdB5hvgnAW3Gg1IG_M"
    }
    
    enum APIRequest: String {
        case scheme = "https"
        case host = "api.unsplash.com"
        case path = "/photos"
        case page = "page"
        case perPage = "per_page"
    }
}

final class NetworkManager {
    private static var page = 1
    private static let photosPerPage = 30
    
    static func getPhotos(completion: @escaping ([UnsplashPhoto]?) -> Void) {
        makeRequest { data, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let results = decodeJSON(type: [UnsplashPhoto].self, from: data)
            completion(results)
            self.page += 1
        }
    }
    
    private static func decodeJSON<T: Decodable>(type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(type.self, from: data)
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }
    
    private static func makeRequest(completion: @escaping (Data?, Error?) -> Void) {
        guard let url = createURL() else {
            completion(nil, NSError(domain: "NetworkManager",
                                    code: 400,
                                    userInfo: [NSLocalizedDescriptionKey: "Failed to create URL"]))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(NetworkSettings.APIKey.accessKey.rawValue,
                         forHTTPHeaderField: NetworkSettings.APIKey.authorization.rawValue)
        let task = createDataTask(with: request) { data, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
    private static func createURL() -> URL? {
        var components = URLComponents()
        components.scheme = NetworkSettings.APIRequest.scheme.rawValue
        components.host = NetworkSettings.APIRequest.host.rawValue
        components.path = NetworkSettings.APIRequest.path.rawValue
        components.queryItems = [
            URLQueryItem(name: NetworkSettings.APIRequest.page.rawValue, value: String(page)),
            URLQueryItem(name: NetworkSettings.APIRequest.perPage.rawValue, value: String(photosPerPage))
        ]
        return components.url
    }
    
    private static func createDataTask(with request: URLRequest,
                                       completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
