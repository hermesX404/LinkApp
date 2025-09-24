//
//  FollowButton.swift
//  Link
//
//  Created by KAON SOU on 2025/03/23.
//

import SwiftUI
import FirebaseFirestore


struct FollowButtonView: View {
    let user: User
    let currentUserId: String
    let targetUserId: String
    let width: CGFloat
    let height: CGFloat
    @State private var isFollowing = false
    
    init(user: User, currentUserId: String, targetUserId: String, width: CGFloat = 100, height: CGFloat = 32) {
        self.user = user
        self.currentUserId = currentUserId
        self.targetUserId = targetUserId
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Button {
            Task {
                do {
                    if !isFollowing {
                        try await FollowButtonModel.followUser(currentUserId: currentUserId, targetUserId: targetUserId)
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isFollowing.toggle()
                        }
                    } else {
                        try await FollowButtonModel.unfollowUser(currentUserId: currentUserId, targetUserId: targetUserId)
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isFollowing.toggle()
                        }
                    }
                } catch {
                    print("Follow action failed: \(error.localizedDescription)")
                }
            }
        } label: {
            Text(isFollowing ? "Following" : "Follow")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: width, height: height)
                .background(isFollowing ? Color.white : Color.black)
                .foregroundColor(isFollowing ? Color.gray : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .task {
            do {
                isFollowing = try await FollowButtonModel.checkIfFollowing(currentUserId: currentUserId, targetUserId: targetUserId)
            } catch {
                print("Error checking follow status: \(error.localizedDescription)")
            }
        }
    }
}

struct FollowButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FollowButtonView(
            user: DeveloperPreview.shared.user,
            currentUserId: "user1",
            targetUserId: "user2",
            width: 370,
            height: 40
        )
    }
}
