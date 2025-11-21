import Foundation

enum ApiError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int, String?)
    case networkError(Error)
    case unauthorized
    case paymentRequired
}

class ApiService {
    static let shared = ApiService()
    
    private let baseURL = Constants.apiBaseURL
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
    
    private func createRequest(endpoint: String, method: String, body: Data? = nil) throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = TokenManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    func request<T: Decodable>(endpoint: String, method: String = "GET", body: Encodable? = nil) async throws -> T {
        var requestBody: Data?
        if let body = body {
            requestBody = try JSONEncoder().encode(body)
        }
        
        let request = try createRequest(endpoint: endpoint, method: method, body: requestBody)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.noData
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.self, from: data)
                    return result
                } catch {
                    print("Decoding error: \(error)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response: \(jsonString)")
                    }
                    throw ApiError.decodingError
                }
            case 401:
                TokenManager.shared.deleteToken()
                TokenManager.shared.deleteUser()
                throw ApiError.unauthorized
            case 402:
                throw ApiError.paymentRequired
            default:
                let errorMessage = String(data: data, encoding: .utf8)
                throw ApiError.serverError(httpResponse.statusCode, errorMessage)
            }
        } catch let error as ApiError {
            throw error
        } catch {
            throw ApiError.networkError(error)
        }
    }
}

