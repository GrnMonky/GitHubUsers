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
            }.scrollContentBackground(.hidden)
                .task {
                    // Set loading state to true when data fetching starts
                    isLoading = true
                    // Attempt to fetch GitHub users asynchronously
                    do {
                        users = try await GitHub().getUsers()
                    } catch {
                        // Handle any errors that occur during fetching
                        errorMessage = error.localizedDescription
                        showAlert = true
                    }
                    // Set loading state to false when data fetching completes
                    isLoading = false
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
}

#Preview {
    ContentView()
}
