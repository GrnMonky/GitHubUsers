//
//  GitHubUsers.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/3/24.
//

import Foundation

struct GitHub {
    
    protocol User {
        var login: String { get }
        var avatarURL: String? { get }
        var id: Int { get }
    }
    
    struct ListUser: Codable, Identifiable, GitHub.User {
        
        let login: String
        let avatarURL: String?
        let id: Int
        
        private enum CodingKeys: String, CodingKey {
            case login, id
            case avatarURL = "avatar_url"
        }
        
    }
    
    struct DeatailedUser: Codable, Identifiable, GitHub.User {
        
        let login: String
        let avatarURL: String?
        let id: Int
        let name: String?
        let followers: Int
        let following: Int
        
        init(login: String, avatarURL: String?, id: Int, name: String, followers: Int, following: Int) {
            self.login = login
            self.avatarURL = avatarURL
            self.id = id
            self.name = name
            self.followers = followers
            self.following = following
        }
        
        private enum CodingKeys: String, CodingKey {
            case login, id, name, followers, following
            case avatarURL = "avatar_url"
        }
        
    }
    
    struct Repo: Codable, Identifiable {
        
        let id: Int
        let name: String
        let language: String?
        let stars: Int
        let description: String?
        let url: String
        let forked: Bool
        
        private enum CodingKeys: String, CodingKey {
            case id,name,language,description
            case stars = "stargazers_count"
            case url = "html_url"
            case forked = "fork"
        }
        
    }
}
