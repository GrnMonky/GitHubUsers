//
//  GitHub.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/2/24.
//

import Foundation

// Constants
fileprivate let GitHubUrl = "https://api.github.com/users"

// Enum for networking errors
enum NetworkingError: Error {
    case invalidURL
}

// Networking struct for handling API requests
fileprivate struct Networking {
    
    // Function to fetch data from URLSession and decode it into a decodable type
    static func fromURLSession<T: Decodable>(_ urlString: String) async throws -> (data: T, nextPageLink: URL?, prevPageLink: URL?) {
        
        // Convert urlString to URL
        guard let url = URL(string: urlString) else {
            throw NetworkingError.invalidURL
        }
        
        // Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add Authorization header if GitHubToken is available
        if let token = ProcessInfo.processInfo.environment["GitHubToken"] {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Fetch data from URLSession
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Decode data into specified type
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)
        
        // Check for the next and previous page links in the response headers
        let nextPageLink = getNextPageLink(from: response, rel: "next")
        let prevPageLink = getNextPageLink(from: response, rel: "prev")
        
        return (result, nextPageLink, prevPageLink)
    }
    
    // Helper function to extract the link header from the HTTP response
    static func getNextPageLink(from response: URLResponse?, rel: String) -> URL? {
        guard let httpResponse = response as? HTTPURLResponse,
              let linkHeader = httpResponse.allHeaderFields["Link"] as? String else {
            return nil
        }
        
        // Split the link header into individual links
        let links = linkHeader.components(separatedBy: ",")
        
        // Find the link for the specified relation
        for link in links {
            let components = link.components(separatedBy: ";")
            if components.count < 2 { continue }
            let linkValue = components[0].trimmingCharacters(in: .whitespaces)
            let relAttribute = components[1].trimmingCharacters(in: .whitespaces)
            if relAttribute == "rel=\"\(rel)\"" {
                let urlStartIndex = linkValue.index(after: linkValue.startIndex)
                let urlEndIndex = linkValue.index(before: linkValue.endIndex)
                let urlString = String(linkValue[urlStartIndex..<urlEndIndex])
                return URL(string: urlString)
            }
        }
        
        return nil
    }
}

// Extension for GitHub API related functions
extension GitHub {
    
    // Function to get list of users from GitHub API
    func getUsers(next: String? = nil) async throws -> (data: [GitHub.ListUser], nextPageLink: URL?, prevPageLink: URL?) {
        return try await Networking.fromURLSession(next ?? GitHubUrl)
    }
    
    // Function to get detailed information about a user from GitHub API
    func getDetailedUser(login: String) async throws -> DetailedUser {
        let userUrl = "\(GitHubUrl)/\(login)"
        return try await Networking.fromURLSession(userUrl).data
    }
    
    // Function to get repositories of a user from GitHub API
    func getRepos(login: String) async throws -> [Repo] {
        let reposUrl = "\(GitHubUrl)/\(login)/repos"
        return try await Networking.fromURLSession(reposUrl).data
    }
}
