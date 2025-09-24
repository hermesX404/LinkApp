//
//  ProfileHeaderView.swift
//  Link
//
//  Created by KAON SOU on 2025/03/19.
//

import SwiftUI

struct ProfileHeaderView: View {
    var user: User?
    @State private var showFullScreenAvatar = false
    @State private var showNetworkDiagnostics = false
    
    //格式化关注数
    var formattedFollowers: String {
        guard let count = user?.followersCount else { return "0 followers" }
        if count >= 1_000_000 {
            return String(format: "%.1fm followers", Double(count) / 1_000_000)
        } else if count >= 1_000 {
            return String(format: "%.1fk followers", Double(count) / 1_000)
        } else {
            return "\(count) followers"
        }
    }
    
    init(user: User?) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user?.fullname ?? "")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text(user?.email ?? "")
                            .font(.footnote)
                    }
                    .foregroundStyle(.blue)
                    .padding(.vertical, 5)
                    
                    if let bio = user?.bio, !bio.isEmpty {
                        Text(bio)
                            .font(.callout)
                            .foregroundStyle(.primary)
                            .padding(.bottom, 10)
                    }
                    
                    
                    Text(formattedFollowers)
                        .font(.headline)
                        .foregroundStyle(.gray)
                    
                }
                .padding(.horizontal, 5)
                Spacer()
                
                //头像预览
                Button {
                    showFullScreenAvatar.toggle()
                } label: {
                    CircularProfileImageView(user: user, size: 85)
                }
                .padding(.vertical, 5)
            }
            
            // 网络诊断按钮
            Button("🔍 网络诊断") {
                showNetworkDiagnostics.toggle()
            }
            .font(.caption)
            .foregroundColor(.orange)
            .padding(.top, 5)
        }
        .fullScreenCover(isPresented: $showFullScreenAvatar) {
            FullScreenAvatarView(user: user)
        }
        .alert("网络诊断", isPresented: $showNetworkDiagnostics) {
            Button("运行诊断") {
                NetworkConfigurationHelper.shared.printNetworkDiagnostics()
            }
            Button("关闭", role: .cancel) { }
        } message: {
            Text("点击运行诊断将检查网络连接状态和Firebase服务可访问性。请查看控制台输出。")
        }
        .onAppear {
            // 调试头像信息
            ImageDebugHelper.shared.debugUserProfileImage(user)
            
            // 如果检测到SSL错误，自动运行网络诊断
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                NetworkConfigurationHelper.shared.printNetworkDiagnostics()
            }
        }
    }
}

struct ProfileHeaderiew_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(user: dev.user)
    }
}


/*
 HStack(alignment: .top) {
     VStack(alignment: .leading) {
         VStack(alignment: .leading, spacing: 4) {
             Text(user?.fullname ?? "")
                 .font(.title)
                 .fontWeight(.semibold)
             
             Text(user?.email ?? "")
                 .font(.footnote)
         }
         .foregroundStyle(.blue)
         .padding(.vertical, 5)
         
         
         if let bio = user?.bio, !bio.isEmpty {
             Text(bio)
                 .font(.callout)
                 .foregroundStyle(.primary)
                 .padding(.bottom, 10)
         }
         
         
         Text(formattedFollowers)
             .font(.headline)
             .foregroundStyle(.gray)
         
     }
     .padding(.horizontal, 5)
     Spacer()
 HStack(alignment: .top) {
     Button {
         showFullScreenAvatar.toggle()
     } label: {
         CircularProfileImageView(user: user, size: 75)
     }
 }
 .fullScreenCover(isPresented: $showFullScreenAvatar) {
     FullScreenAvatarView(user: user)
 }
 */
