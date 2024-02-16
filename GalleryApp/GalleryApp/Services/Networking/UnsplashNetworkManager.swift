import Foundation
import os

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

final class UnsplashNetworkManager: NetworkManager {
    private enum Constants {
        static let urlCreationFailureMessage = NSLocalizedString("Failed to create URL for API request", comment: "")
        static let requestFailureMessage = NSLocalizedString("Failed to make the request", comment: "")
        static let jsonDecodingFailureMessage: StaticString = "Failed to decode JSON: %@"
        static let photosPerPage = 30
    }
    
    private var page = 1
    
    func getPhotos(completion: @escaping (Result<[UnsplashPhoto], NetworkError>) -> Void) {
        makeRequest { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.decodeUnsplashPhotos(from: data) { results in
                    completion(.success(results))
                    self.page += 1
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeRequest(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = createURLForAPIRequest(page: page, photosPerPage: Constants.photosPerPage) else {
            completion(.failure(.urlCreationFailure(description: Constants.urlCreationFailureMessage)))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(NetworkSettings.APIKey.accessKey.rawValue,
                         forHTTPHeaderField: NetworkSettings.APIKey.authorization.rawValue)
        let task = createDataTask(with: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(.requestFailed(description: Constants.requestFailureMessage + "\(error)")))
                }
            }
        }
        task.resume()
    }
    
    private func createURLForAPIRequest(page: Int, photosPerPage: Int) -> URL? {
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
    
    private func createDataTask(with request: URLRequest,
                                completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            }
        }
    }
    
    private func decodeUnsplashPhotos(from data: Data, completion: @escaping ([UnsplashPhoto]) -> Void) {
        do {
            let decoder = JSONDecoder()
            let results = try decoder.decode([UnsplashPhoto].self, from: data)
            completion(results)
        } catch {
            os_log(Constants.jsonDecodingFailureMessage, log: OSLog.default, type: .error, error.localizedDescription)
        }
    }
}
