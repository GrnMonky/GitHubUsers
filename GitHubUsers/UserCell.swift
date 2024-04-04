//
//  UserCell.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/2/24.
//

import SwiftUI

struct UserCell: View {
    
    let user: GitHub.User
    
    var body: some View {
        HStack(spacing: 15) {
            // Display user avatar asynchronously
            AsyncImage(url: URL(string: user.avatarURL ?? "")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                // Placeholder view while image is loading
                ProgressView()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            
            // Display user login name
            Text(user.login)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
#Preview {
    VStack {
        UserCell(user: GitHub.ListUser(login: "octocat", avatarURL: "https://via.placeholder.com/50x50", id: 1))
        Spacer()
    }
}
