//
//  ContentView.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/2/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var users: [GitHub.ListUser] = []
    
    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink(destination: UserDetails(user: user)) {
                    UserCell(user: user)
                }
            }.task {
                do {
                    users = try await GitHub().getUsers()
                } catch {
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
