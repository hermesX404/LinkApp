//
//  LikeButtonView.swift
//  Link
//
//  Created by KAON SOU on 2025/03/25.
//

import SwiftUI
import FirebaseFirestore

extension Notification.Name {
    static let linkLiked = Notification.Name("linkLiked")
}

struct LikeButtonView: View {
    let link: Link
    let currentUserId: String
    let targetUserId: String
    @State private var isLiked = false
    @State private var likes = 0
    
    var body: some View {
        Button {
            //切换点赞状态并立即更新点赞数
            isLiked.toggle()
            likes += isLiked ? 1 : -1
            
            //震动反馈
            let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            NotificationCenter.default.post(name: .linkLiked, object: nil)
            //异步更新服务器
            Task {
                do {
                    try await LikeButtonManager.updateLikes(for: link, currentUserId: currentUserId, targetUserId: targetUserId , increment: isLiked)
                } catch {
                    //如果失败回归本地状态
                    isLiked.toggle()
                    likes -= isLiked ? 1 : -1
                    print("Error updating likes: \(error.localizedDescription)")
                }
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundStyle(isLiked ? Color.red : Color(hue: 0.612, saturation: 0.373, brightness: 0.872))
                    .scaleEffect(isLiked ? 1.2 : 1.0)
                    .animation(.spring(), value: isLiked)
                if likes > 0 {
                    Text("\(likes)")
                        .font(.callout)
                        .foregroundStyle(isLiked ? Color.red : Color(hue: 0.612, saturation: 0.373, brightness: 0.872))
                }
            }
        }
        .onAppear {
            likes = link.likes
            Task {
                do {
                    isLiked = try await LikeButtonManager.checkIfLiked(for: link, currentUserId: currentUserId)
                } catch {
                    print("Error checking liked status: \(error.localizedDescription)")
                }
            }
        }
    }
}


struct LikeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LikeButtonView(
            link: DeveloperPreview.shared.link,
            currentUserId: DeveloperPreview.shared.user.id,
            targetUserId: DeveloperPreview.shared.link.ownerUid
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
