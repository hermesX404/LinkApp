//
//  ProfileView.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/10.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 20) {
            ProfileHeaderView(user: user)
            
            if let currentUser = UserService.shared.currentUser {
                FollowButtonView(user: user, currentUserId: currentUser.id, targetUserId: user.id, width: 370, height: 40)
            }
            UserContentListView(user: user)
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
