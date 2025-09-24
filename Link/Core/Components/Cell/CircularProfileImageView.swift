//
//  CircularProfileImageView.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/11.
//

import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
    var user: User?
    var size: CGFloat = 44
    @State private var currentImageUrl: String?
    @State private var isLoading = false
    
    init(user: User?, size: CGFloat = 44) {
        self.user = user
        self.size = size
    }
    
    var body: some View {
        Group {
            if let imageUrl = currentImageUrl, !imageUrl.isEmpty {
                KFImage(URL(string: imageUrl))
                    .placeholder {
                        ProgressView()
                            .frame(width: size, height: size)
                    }
                    .onFailure { error in
                        print("DEBUG: Failed to load profile image: \(error.localizedDescription)")
                        print("DEBUG: Image URL: \(imageUrl)")
                        
                        // 尝试刷新Firebase Storage URL
                        refreshFirebaseURL(imageUrl)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
            } else {
                defaultAvatarView
            }
        }
        .onAppear {
            setupImageURL()
        }
        .onChange(of: user?.profileImageUrl) { newValue in
            setupImageURL()
        }
    }
    
    private var defaultAvatarView: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundStyle(Color(.systemGray4))
            .overlay(
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
    }
    
    private func setupImageURL() {
        guard let imageUrl = user?.profileImageUrl, !imageUrl.isEmpty else {
            currentImageUrl = nil
            return
        }
        
        // 验证URL格式
        if let url = URL(string: imageUrl), url.scheme != nil {
            currentImageUrl = imageUrl
            
            // 检查Firebase Storage文件是否存在
            FirebaseStorageHelper.shared.checkImageExists(imageUrl: imageUrl) { exists, error in
                if let error = error {
                    print("DEBUG: Firebase Storage check failed: \(error.localizedDescription)")
                    // 如果检查失败，尝试刷新URL
                    refreshFirebaseURL(imageUrl)
                } else if !exists {
                    print("DEBUG: Image file does not exist in Firebase Storage")
                    // 文件不存在，尝试刷新URL
                    refreshFirebaseURL(imageUrl)
                }
            }
        } else {
            print("DEBUG: Invalid image URL format: \(imageUrl)")
            currentImageUrl = nil
        }
    }
    
    private func refreshFirebaseURL(_ oldUrl: String) {
        FirebaseStorageHelper.shared.getFreshDownloadURL(for: oldUrl) { newUrl, error in
            if let error = error {
                print("DEBUG: Failed to refresh Firebase URL: \(error.localizedDescription)")
                // 刷新失败，保持原URL或显示默认头像
            } else if let newUrl = newUrl {
                print("DEBUG: Successfully refreshed Firebase URL")
                DispatchQueue.main.async {
                    self.currentImageUrl = newUrl
                }
            }
        }
    }
}

struct CircularProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProfileImageView(user: dev.user)
    }
}
