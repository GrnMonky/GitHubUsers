//
//  GitHubUsers.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/3/24.
//

import Foundation

struct GitHub {
    
    // Define protocol for GitHub User
    protocol User {
        var login: String { get }
        var avatarURL: String? { get }
        var id: Int { get }
    }

    // Struct for representing a GitHub user in a list
    struct ListUser: Codable, Identifiable, User {
        let login: String
        let avatarURL: String?
        let id: Int
        
        // Coding keys for decoding
        private enum CodingKeys: String, CodingKey {
            case login, id
            case avatarURL = "avatar_url"
        }
    }

    // Struct for representing a detailed GitHub user
    struct DetailedUser: Codable, Identifiable, User {
        let login: String
        let avatarURL: String?
        let id: Int
        let name: String?
        let followers: Int
        let following: Int
        
        // Initialize with required properties
        init(login: String, avatarURL: String?, id: Int, name: String?, followers: Int, following: Int) {
            self.login = login
            self.avatarURL = avatarURL
            self.id = id
            self.name = name
            self.followers = followers
            self.following = following
        }
        
        // Coding keys for decoding
        private enum CodingKeys: String, CodingKey {
            case login, id, name, followers, following
            case avatarURL = "avatar_url"
        }
    }

    // Struct for representing a GitHub repository
    struct Repo: Codable, Identifiable {
        let id: Int
        let name: String
        let language: String?
        let stars: Int
        let description: String?
        let url: String
        let forked: Bool
        
        // Coding keys for decoding
        private enum CodingKeys: String, CodingKey {
            case id, name, language, description
            case stars = "stargazers_count"
            case url = "html_url"
            case forked = "fork"
        }
    }
}
