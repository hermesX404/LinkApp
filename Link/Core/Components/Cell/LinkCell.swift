//
//  LinkCall.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/11.
//

import SwiftUI
import FirebaseFirestore

struct LinkCell: View {
    let link: Link
    @State private var navigateToDetail = false
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                CircularProfileImageView(user: link.user)
                    
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        // 显示用户名
                        Text(link.user?.fullname ?? "Unknown User")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                        
                        // 显示帖子位置
                        if let location = link.location, !location.isEmpty {
                            HStack(spacing: 2) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundStyle(.gray)
                                    .font(.caption)
                                Text(location)
                                    .foregroundStyle(.gray)
                                    .font(.caption)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        // 显示发帖时间
                        Text(link.timestamp.timestampString())
                            .font(.caption)
                            .foregroundStyle(Color(.systemGray3))
                        
                        // 操作帖子
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Color(.darkGray))
                        }
                    }
                    
                    //显示帖子内容
                    Text(link.caption)
                        .foregroundColor(.primary)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                    
                    
                    //与帖子互动选项
                    HStack(spacing: 20) {
                        
                        LikeButtonView(link: link, currentUserId: AuthService.shared.userSession?.uid ?? "", targetUserId: link.ownerUid)
                        
                        HStack(spacing: 2) {
                            Button {
                                let generator = UIImpactFeedbackGenerator(style: .heavy)
                                generator.impactOccurred()
                                navigateToDetail = true
                            } label: {
                                Image(systemName: "bubble.right")
                            }

                            NavigationLink(
                                destination: LinkDetailView(link: link, autoFocusCommentField: true),
                                isActive: $navigateToDetail
                            ) {
                                EmptyView()
                            }
                            .hidden()
                            if let count = link.commentsCount, count > 0 {
                                Text("\(count)")
                                    .font(.callout)
                            }
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "arrow.2.squarepath")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "paperplane")
                        }
                    }
                    .foregroundStyle(Color(hue: 0.612, saturation: 0.373, brightness: 0.872))
                    .padding(.vertical, 5)
                }
            }
            Divider()
                .padding(.horizontal, -12)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 12)
    }
}

struct LinkCell_Preview: PreviewProvider {
    static var previews: some View {
        LinkCell(link: dev.link)
    }
}
