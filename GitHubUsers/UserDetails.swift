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
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            // Display user avatar asynchronously
            AsyncImage(url: URL(string: user.avatarURL ?? "")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit) // or .fill
            } placeholder: {
                // Placeholder view while image is loading
                ProgressView()
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            
            // Display user login name
            Text(user.login)
            
            // Display additional user details if available
            if let details = user as? GitHub.DetailedUser {
                Text(details.name ?? "")
                Text("Followers: \(details.followers)")
                Text("Following: \(details.following)")
            }
            
            // List of user repositories
            List(repos.filter{$0.forked == false}) { repo in
                NavigationLink(destination: WebView(url: URL(string: repo.url)!)) {
                    RepoCell(repo: repo)
                }.listRowSeparator(.hidden)
            }.scrollContentBackground(.hidden)
                .task {
                    // Attempt to fetch user repositories asynchronously
                    do {
                        repos = try await GitHub().getRepos(login: user.login)
                    } catch {
                        // Handle any errors that occur during fetching
                        errorMessage = error.localizedDescription
                        showAlert = true
                    }
                }
        }
        .task {
            // Attempt to fetch detailed user information asynchronously if it's not already available
            if !(user is GitHub.DetailedUser) {
                do {
                    self.user = try await GitHub().getDetailedUser(login: user.login)
                } catch {
                    // Handle any errors that occur during fetching
                    errorMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    UserDetails(user: GitHub.ListUser(login: "octocat", avatarURL: "https://via.placeholder.com/100x100", id: 1))
}
