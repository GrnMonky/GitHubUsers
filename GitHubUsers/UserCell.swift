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
        HStack {
            AsyncImage(url: URL(string: user.avatarURL ?? "")) { image in
              image.resizable()
                .aspectRatio(contentMode: .fit) // or .fill
            } placeholder: {
              ProgressView()
            }
            .frame(width: 50, height: 50)
                        .clipShape(Circle())
            Text(user.login)
        }
    }
}

#Preview {
    VStack {
        UserCell(user: GitHub.ListUser(login: "octocat", avatarURL: "https://via.placeholder.com/50x50", id: 1))
        Spacer()
    }
}
