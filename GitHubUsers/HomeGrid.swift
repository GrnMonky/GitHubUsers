//
//  HomeGrid.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/5/24.
//

import SwiftUI

struct HomeGrid: View {
    // MARK: - Properties
    var namespace : Namespace.ID
    
    // State variable to hold the list of GitHub users
    var viewModel: HomeVM = HomeVM()
    
    // MARK: - Body
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    
                    ForEach(viewModel.users) { user in
                        NavigationLink(destination: UserDetails(user: user)) {
                            UserCell(user: user)
                        }
                        .matchedGeometryEffect(id: user.id, in: namespace)
                        .listRowSeparator(.hidden)
                        .task {
                            // Load more users when reaching the end of the list
                            if viewModel.shouldLoadMoreUsers(user) {
                                await viewModel.loadMoreUsers()
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .padding()
                .onAppear() {
                    if viewModel.users.isEmpty {
                        viewModel.loadInitialUsers()
                    }
                }
                // Display a loading indicator while data is being fetched
                .overlay(loadingView(), alignment: .center)
        }
    }
    
    // Function to display a loading view while data is being fetched
    private func loadingView() -> some View {
        // Only display ProgressView when isLoading is true
        if viewModel.isLoading {
            return AnyView(ProgressView())
        } else {
            return AnyView(EmptyView())
        }
    }
}

#Preview {
    @Namespace var namespace
    return HomeGrid(namespace: namespace)
}
