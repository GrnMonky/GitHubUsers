//
//  GitHub.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/2/24.
//

import Foundation

fileprivate let GitHubUrl = "https://api.github.com/users"

private func fromURLSession<T:Decodable>(_ urlString: String) async throws -> T {
    
    guard let url = URL(string: urlString) else {
        throw NSError(domain: "InvalidURL", code: 0, userInfo: nil)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decoder = JSONDecoder()
    let result = try decoder.decode(T.self, from: data)
    
    return result
}

extension GitHub {
    
    func getUsers() async throws -> [GitHub.ListUser] {
        return try await fromURLSession(GitHubUrl)
    }
    
    func getDeatailedUser(login: String) async throws -> DeatailedUser {
        return try await fromURLSession("\(GitHubUrl)/\(login)")
    }
    
    func getRepos(login: String) async throws -> [Repo] {
        return try await fromURLSession("\(GitHubUrl)/\(login)/repos")
    }
    
}
