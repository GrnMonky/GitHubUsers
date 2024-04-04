//
//  RepoCell.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/3/24.
//

import SwiftUI

struct RepoCell: View {
    
    let repo: GitHub.Repo
    
    var body: some View {
        // Horizontal stack to arrange the content
        HStack {
            // Vertical stack to organize the texts vertically
            VStack(alignment: .leading, spacing: 4) {
                // Repository name
                Text(repo.name)
                    .font(.headline) // Larger font size
                    .foregroundColor(.blue) // Blue color for better visibility
                // Repository description
                Text(repo.description ?? "")
                    .font(.subheadline) // Smaller font size
                    .foregroundColor(.gray) // Gray color for better readability
                // Repository language
                Text(repo.language ?? "")
                    .font(.caption) // Even smaller font size
                    .foregroundColor(.green) // Green color for better visibility
            }
            Spacer() // Spacer to push the star icon to the right
            // Star icon indicating the number of stars
            Image(systemName: "star")
                .foregroundColor(.yellow) // Yellow color for better visibility
            // Number of stars
            Text("\(repo.stars)")
                .font(.caption) // Smaller font size
                .foregroundColor(.gray) // Gray color for better readability
        }
        // Apply padding to the cell
        .padding()
        // Apply background color to the cell
        .background(Color.white)
        // Apply corner radius to the cell for rounded corners
        .cornerRadius(8)
        // Apply shadow to the cell for depth effect
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    VStack {
        RepoCell(repo: GitHub.Repo(id: 1, name: "Repo", language: "Python", stars: 100, description: "My First Repo",url: "", forked: true))
        Spacer()
    }
}
