//
//  GitHubService.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import Foundation

public class GitHubService {

    /// To get the list of users from GitHub's API
    /// - Parameter page: pagination object; current page, total count, and next page URL
    /// - Parameter count: the number of users in one request, default is 20
    /// - Parameter completion: completion event with list of users & next page URL or API error result
    func getUsers(page: Pagination, count: Int = Constant.itemsPerPage, completion: @escaping (_ result: Result<User.GitHubSuccessResponse, String>) -> Void) {

        let parameters: [String: String] = [
            Constant.Pagination.page: "\(page.page)",
            Constant.Pagination.count: "\(count)",
            Constant.Pagination.since: Constant.userIdBound
        ]

        // If not pagination URL, construct the intial URL
        var url: URL
        if let paginatedURL = URL(string: page.nextPageURL) {
            url = paginatedURL
        } else if let initialURL = APIService().constructURL(host: .github, endpoint: .users, queries: parameters) {
            url = initialURL
        } else {
            fatalError("Invalid URL")
        }

        APIService().request(.get, url: url) { [](result) in
            switch result {
            case .success(let response):
                let headers = response.res.allHeaderFields
                guard
                    let max = headers[Constant.RateLimit.max] as? String, let maxCount = Int(max),
                    let remaining = headers[Constant.RateLimit.remaining] as? String, let remainingCount = Int(remaining),
                    (remainingCount < maxCount)
                else {
                    // GitHub's request limit handler
                    if let resetTime = headers[Constant.RateLimit.resetTime] as? Int {
                        completion(.failure(APIError.reachedRequestLimit(TimeInterval(resetTime)).errorMessage))
                    } else {
                        completion(.failure(APIError.generalError.errorMessage))
                    }
                    return
                }

                guard let data = response.data, let users = try? JSONDecoder().decode([User].self, from: data) else {
                    completion(.failure(APIError.generalError.errorMessage))
                    return
                }

                let paginationLink = headers[Constant.Pagination.link] as? String
                let response: User.GitHubSuccessResponse = (users, self.parseHeaderLink(paginationLink))
                completion(.success(response))
            case .failure:
                completion(.failure(APIError.generalError.errorMessage))
            }
        }
    }
}

extension GitHubService {

    private struct Constant {
        static let userIdBound = "100"
        static let itemsPerPage = 20

        /// https://developer.github.com/v3/#pagination
        struct Pagination {
            static let page = "page"
            static let count = "per_page"
            static let since = "since"
            static let link = "Link"
        }

        /// https://developer.github.com/v3/#rate-limiting
        struct RateLimit  {
            static let max = "X-RateLimit-Limit"
            static let remaining = "X-RateLimit-Remaining"
            static let resetTime = "X-RateLimit-Reset"
        }
    }

    /// Parse header links to get the next page URL (reference: https://developer.github.com/v3/#link-header)
    /// - Parameter links: string's component
    private func parseHeaderLink(_ links: String?) -> String {
        // i.e: <https://api.github.com/users?page=2&per_page=10&since=120>; rel="next", <https://api.github.com/users{?since}>; rel="first"
        guard let links = links else { return "" }

        let result = links
            .split(separator: ",")
            .filter({ $0.contains("next") })
            .joined()
            .replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: "; rel=\"next\"", with: "")

        return result
    }
}
