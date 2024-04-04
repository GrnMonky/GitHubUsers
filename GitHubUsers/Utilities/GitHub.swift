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
    static func fromURLSession<T: Decodable>(_ urlString: String) async throws -> T {
        
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
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode data into specified type
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)
        
        return result
    }
}

// Extension for GitHub API related functions
extension GitHub {
    
    // Function to get list of users from GitHub API
    func getUsers() async throws -> [GitHub.ListUser] {
        return try await Networking.fromURLSession(GitHubUrl)
    }
    
    // Function to get detailed information about a user from GitHub API
    func getDetailedUser(login: String) async throws -> DetailedUser {
        let userUrl = "\(GitHubUrl)/\(login)"
        return try await Networking.fromURLSession(userUrl)
    }
    
    // Function to get repositories of a user from GitHub API
    func getRepos(login: String) async throws -> [Repo] {
        let reposUrl = "\(GitHubUrl)/\(login)/repos"
        return try await Networking.fromURLSession(reposUrl)
    }
}
