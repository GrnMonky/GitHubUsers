//
//  UserDetails.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/2/24.
//

import SwiftUI

struct UserDetails: View {
    
    let user: GitHub.User
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.avatarURL ?? "")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit) // or .fill
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            Text(user.login)
            Spacer()
        }.padding()
    }
}

#Preview {
    UserDetails(user: GitHub.User(login: "Landon", avatarURL: "https://via.placeholder.com/100x100", id: 1))
}
