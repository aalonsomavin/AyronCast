import Foundation

enum APIConfiguration {
    static var baseURL: URL {
        if let urlString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
           let url = URL(string: urlString) {
            return url
        }
        return URL(string: "http://localhost:8000")!
    }
}
