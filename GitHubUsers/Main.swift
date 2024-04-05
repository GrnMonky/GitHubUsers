//
//  Main.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/5/24.
//

import SwiftUI

struct Main: View {
    @State private var isShowingFirstView = false
    
    @State private var viewModel: HomeVM = HomeVM()
        
        var body: some View {
            NavigationView {
                VStack {
                    
                    Toggle("Grid", isOn: $isShowingFirstView)
                        .padding()
                    
                    TextField("Search", text: $viewModel.searchText, onCommit: viewModel.loadInitialUsers)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    if isShowingFirstView {
                        HomeGrid(viewModel: viewModel)
                    } else {
                        ContentView(viewModel: viewModel)
                    }
                }
            }// Set navigation bar title
            .navigationBarTitle("GitHub Users", displayMode: .inline)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear() {
                if viewModel.users.isEmpty {
                    viewModel.loadInitialUsers()
                }
            }
        }
}

#Preview {
    Main()
}
