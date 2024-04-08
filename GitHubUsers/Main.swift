//
//  Main.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/5/24.
//

import SwiftUI

struct Main: View {
    @State private var isShowingFirstView = false
    
    @Namespace var mainNamespace
    
    @State private var viewModel: HomeVM = HomeVM()
        
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    
                    
                    Toggle("Grid", isOn: $isShowingFirstView.animation())
                    
                    Button("Slow") { withAnimation(.easeInOut(duration: 1.0)) { isShowingFirstView.toggle() } }
                }
                .padding()
                
                TextField("Search", text: $viewModel.searchText, onCommit: viewModel.loadInitialUsers)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(maxWidth: .infinity)
                
                if isShowingFirstView {
                    HomeGrid(namespace: mainNamespace, viewModel: viewModel)
                } else {
                    ContentView(namespace: mainNamespace, viewModel: viewModel)
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
