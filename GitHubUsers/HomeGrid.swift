//
//  HomeGrid.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/5/24.
//

import SwiftUI

struct HomeGrid: View {
    // MARK: - Properties
    
    // State variable to hold the list of GitHub users
    @State var viewModel: HomeVM = HomeVM()
    
    // MARK: - Body
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    TextField("Search", text: $viewModel.searchText, onCommit: viewModel.loadInitialUsers)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    ForEach(viewModel.users) { user in
                        NavigationLink(destination: UserDetails(user: user)) {
                            UserCell(user: user)
                        }
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
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
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
    HomeGrid()
}
