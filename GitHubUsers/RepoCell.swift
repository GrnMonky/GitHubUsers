//
//  RepoCell.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/3/24.
//

import SwiftUI

struct RepoCell: View {
    
    let repo: GitHub.Repo
    
    var body: some View {
        HStack {
            Text(repo.name)
            Text(repo.description ?? "")
            Text(repo.language ?? "")
            Text("\(repo.stars)")
        }
    }
}

#Preview {
    VStack {
        RepoCell(repo: GitHub.Repo(id: 1, name: "Repo", language: "Python", stars: 100, description: "My First Repo",url: "", forked: true))
        Spacer()
    }
}
