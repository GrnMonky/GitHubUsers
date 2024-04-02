//
//  ContentView.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/2/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var users: [GitHub.User] = []
    
    var body: some View {
        List(users) { user in
            UserCell(user: user)
        }.task {
            do {
                users = try await GitHub().getUsers()
            } catch {
                
            }
        }
    }
}

#Preview {
    ContentView()
}
