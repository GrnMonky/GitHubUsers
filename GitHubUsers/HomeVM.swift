//
//  HomeVM.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/5/24.
//

import Foundation

@Observable
class HomeVM {
    // MARK: - Properties
    
    // State variable to hold the list of GitHub users
    var users: [GitHub.ListUser] = []
    
    // State variable to hold the URL for the next page
    var nextPageLink: URL? = nil
    
    // State variable to control the presentation of the alert
    var showAlert = false
    
    // State variable to hold the error message
    var errorMessage = ""
    
    // State variable to track loading state
    var isLoading = false
    
    // State variable to hold the search query
    var searchText = ""
    
    // MARK: - Helper Functions
    
    // Function to check if more users should be loaded based on the currently displayed user
    func shouldLoadMoreUsers(_ user: GitHub.ListUser) -> Bool {
        guard let lastUser = users.last else {
            return false
        }
        return user.id == lastUser.id
    }
    
    // Function to load more users
    func loadMoreUsers() async {
        guard let nextLink = nextPageLink else {
            return
        }
        
        // Set loading state to true when data fetching starts
        isLoading = true
        
        // Attempt to fetch more GitHub users asynchronously
        do {
            var newUsers: [GitHub.ListUser]?
            var newNextPageLink: URL?
            // Fetch new users, next page link, ToDo: Make use of previous page link
            if searchText.isEmpty {
                (newUsers, newNextPageLink, _) = try await GitHub().getUsers(next: nextLink.absoluteString)
            } else {
                (newUsers, newNextPageLink, _) = try await GitHub().searchUsers(next: nextLink)
            }
            
            if let newUsers = newUsers {
                users.append(contentsOf: newUsers)
            }
            nextPageLink = newNextPageLink
        } catch {
            // Handle any errors that occur during fetching
            errorMessage = error.localizedDescription
            showAlert = true
        }
        // Set loading state to false when data fetching completes
        isLoading = false
    }
    
    func loadInitialUsers() {
        // Fetch initial GitHub users asynchronously when the view appears
        Task {
            do{
                if searchText.isEmpty {
                    let (initialUsers, initialNextPageLink, _) = try await GitHub().getUsers()
                    users = initialUsers
                    nextPageLink = initialNextPageLink
                } else {
                    let (searchResults, nextPageLink, _) = try await GitHub().searchUsers(query: searchText)
                    users = searchResults
                    self.nextPageLink = nextPageLink
                }
            } catch {
                // Handle any errors that occur during search
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
}
