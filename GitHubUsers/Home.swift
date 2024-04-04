//
//  ContentView.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/2/24.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    
    // State variable to hold the list of GitHub users
    @State private var users: [GitHub.ListUser] = []
    
    // State variable to hold the URL for the next page
    @State private var nextPageLink: URL? = nil
    
    // State variable to control the presentation of the alert
    @State private var showAlert = false
    
    // State variable to hold the error message
    @State private var errorMessage = ""
    
    // State variable to track loading state
    @State private var isLoading = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink(destination: UserDetails(user: user)) {
                    UserCell(user: user)
                }.listRowSeparator(.hidden)
                .task {
                    // Load more users when reaching the end of the list
                    if shouldLoadMoreUsers(user) {
                        loadMoreUsers()
                    }
                }
            }.scrollContentBackground(.hidden)
                .task {
                    // Attempt to fetch GitHub users asynchronously when the view appears
                    do {
                        let (initialUsers, initialNextPageLink) = try await GitHub().getUsers()
                        users = initialUsers
                        nextPageLink = initialNextPageLink
                    } catch {
                        // Handle any errors that occur during fetching
                        errorMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            // Display a loading indicator while data is being fetched
                .overlay(loadingView(), alignment: .center)
            // Set navigation bar title
                .navigationBarTitle("GitHub Users", displayMode: .inline)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Helper Functions
    
    // Function to display a loading view while data is being fetched
    private func loadingView() -> some View {
        // Only display ProgressView when isLoading is true
        if isLoading {
            return AnyView(ProgressView())
        } else {
            return AnyView(EmptyView())
        }
    }
    
    // Function to check if more users should be loaded based on the currently displayed user
    private func shouldLoadMoreUsers(_ user: GitHub.ListUser) -> Bool {
        guard let lastUser = users.last else {
            return false
        }
        return user.id == lastUser.id
    }
    
    // Function to load more users
    private func loadMoreUsers() {
        guard let nextLink = nextPageLink else {
            return
        }
        
        // Set loading state to true when data fetching starts
        isLoading = true
        
        // Attempt to fetch more GitHub users asynchronously
        Task {
            do {
                let (newUsers, newNextPageLink) = try await GitHub().getUsers(next: nextLink.absoluteString)
                users.append(contentsOf: newUsers)
                nextPageLink = newNextPageLink
            } catch {
                // Handle any errors that occur during fetching
                errorMessage = error.localizedDescription
                showAlert = true
            }
            // Set loading state to false when data fetching completes
            isLoading = false
        }
    }
}

#Preview {
    ContentView()
}
