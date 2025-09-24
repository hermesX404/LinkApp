//
//  UserCell.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/11.
//

import SwiftUI

struct UserCell: View {
    let user: User
    
    var body: some View {
        HStack {
            CircularProfileImageView(user: user)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.fullname)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                
                Text(user.email)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            
            if let currentUser = UserService.shared.currentUser {
                FollowButtonView(user: user, currentUserId: currentUser.id, targetUserId: user.id)
            }
        }
        .padding(.horizontal)
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(user: dev.user)
    }
}
