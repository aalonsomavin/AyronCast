import Foundation

enum AyronAPIError: Error, LocalizedError {
    case invalidResponse
    case httpStatus(Int)
    case notAuthenticated

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response."
        case .httpStatus(let code):
            return "Request failed with status \(code)."
        case .notAuthenticated:
            return "Not authenticated."
        }
    }
}

struct AyronAPIClient {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func healthCheck() async throws -> Bool {
        let url = APIConfiguration.baseURL.appendingPathComponent("health")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw AyronAPIError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            throw AyronAPIError.httpStatus(http.statusCode)
        }
        return true
    }
}
