//
//  CommentCell.swift
//  Link
//
//  Created by KAON SOU on 2025/03/31.
//

import SwiftUI
import FirebaseFirestore


struct CommentCell: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            CircularProfileImageView(user: comment.user)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(comment.user?.fullname ?? "Unknown User")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                    Text(comment.timestamp.dateValue(), style: .time)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color(.darkGray))
                    }
                    
                }
                
                Text(comment.content)
                    .font(.body)
                    .padding(.vertical, 5)
                
            }
            Spacer()
        }
    }
}

#Preview {
    CommentCell(comment: DeveloperPreview.shared.comment)
}
