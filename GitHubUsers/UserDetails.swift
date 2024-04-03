//
//  UserDetails.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/2/24.
//

import SwiftUI

struct UserDetails: View {
    
    @State var user: GitHub.User
    @State var repos: [GitHub.Repo] = []
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.avatarURL ?? "")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit) // or .fill
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            Text(user.login)
            if let details = user as? GitHub.DeatailedUser {
                Text(details.name ?? "")
                Text("Followers: \(details.followers)")
                Text("Following: \(details.following)")
            }
            List(repos.filter{$0.forked == false}) { repo in
                NavigationLink(destination: WebView(url: URL(string: repo.url)!)) {
                            RepoCell(repo: repo)
                        }
            }.task {
                do {
                    repos = try await GitHub().getRepos(login: user.login)
                } catch {
                    
                }
            }
        }.padding().task {
            do {
                if !(user is GitHub.DeatailedUser) {
                    self.user = try await GitHub().getDeatailedUser(login: user.login)
                }
            } catch {
                
            }
        }
    }
}

#Preview {
    UserDetails(user: GitHub.ListUser(login: "octocat", avatarURL: "https://via.placeholder.com/100x100", id: 1))
}
