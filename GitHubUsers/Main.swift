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
                    
                    if isShowingFirstView {
                        HomeGrid(viewModel: viewModel)
                    } else {
                        ContentView(viewModel: viewModel)
                    }
                }
            }// Set navigation bar title
            .navigationBarTitle("GitHub Users", displayMode: .inline)
        }
}

#Preview {
    Main()
}
