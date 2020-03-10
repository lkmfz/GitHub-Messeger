//
//  APIService.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import Foundation

/// Base layer of network-related service
public class APIService {

    public typealias APIResponse = (res: HTTPURLResponse, data: Data?)

    /// List of base URL
    public enum Host: String {
        case github = "api.github.com"
    }


    /// List of URL's path or endpoint
    public enum Endpoint: String {
        case users = "/users"
    }


    /// List of HTTP method
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }


    /// To construct a URL given the components
    /// - Parameter host: base URL component
    /// - Parameter endpoint: URL's path endpoint
    /// - Parameter queries: URL's queries
    public func constructURL(host: APIService.Host, endpoint: APIService.Endpoint, queries: [String: String] = [:]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.rawValue
        components.path = endpoint.rawValue
        components.queryItems = queries.map({ URLQueryItem(name: $0.key, value: $0.value) })
        return components.url
    }


    /// To make a HTTP request to any of API services
    /// - Parameter method: HTTP method. i.e: "GET", "POST", "PATCH", etc
    /// - Parameter url: request's url
    /// - Parameter headers: request's header
    /// - Parameter parameters: request's parameters
    /// - Parameter completion: completion event with HTTPResponse & Data or error result
    public func request(_ method: APIService.Method, url: URL, headers: [String: String] = [:], parameters: [String: Any] = [:], completion: @escaping (_ result: Result<APIResponse, Error>) -> Void) {

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue

        if method != .get {
            // As per iOS13, GET request is not allowed to append params in the body (https://stackoverflow.com/a/56973866)
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            guard (200..<300 ~= httpResponse.statusCode) else {
                completion(.failure(APIError.invalidStatusCode(httpResponse.statusCode)))
                return
            }

            let response: APIResponse = (httpResponse, data)
            completion(.success(response))
        })

        task.resume()
    }
}

/// Type of API error
public enum APIError: Error {
    case invalidStatusCode(Int)
    case reachedRequestLimit(TimeInterval)
    case invalidResponse
    case invalidData
    case generalError

    var errorMessage: String {
        switch self {
        case .invalidStatusCode(let statusCode):
            return "Invalid status code: \(statusCode)"
        case .reachedRequestLimit(let resetTime):
            // GitHub's API requests limit
            let date = Date(timeIntervalSince1970: resetTime)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return "GitHub's API request has reached hourly count limit. \nIt will be available again after\n\(formatter.string(from: date))"
        default:
            return "Sorry, something went wrong.. 😢"
        }
    }
}
