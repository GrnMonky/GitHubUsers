//
//  GitHub.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/2/24.
//

import Foundation

struct GitHub {
    
    struct User: Codable {
        let login: String
        let avatarURL: String?

        private enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url"
        }
    }

    func getUsers() async throws -> [User] {
        let urlString = "https://api.github.com/users"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "InvalidURL", code: 0, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let users = try decoder.decode([User].self, from: data)
        
        return users
    }
}
