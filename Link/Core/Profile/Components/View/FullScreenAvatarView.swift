//
//  FullScreenAvatarView.swift
//  Link
//
//  Created by KAON SOU on 2025/03/25.
//

import SwiftUI
import Kingfisher

struct FullScreenAvatarView: View {
    var user: User?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button("关闭") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .padding()
                }
                
                Spacer()
                
                if let imageUrl = user?.profileImageUrl, !imageUrl.isEmpty {
                    if let url = URL(string: imageUrl), url.scheme != nil {
                        KFImage(url)
                            .placeholder {
                                VStack {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                    Text("加载中...")
                                        .foregroundColor(.white)
                                        .padding(.top)
                                }
                            }
                            .onFailure { error in
                                print("DEBUG: Failed to load full screen avatar: \(error.localizedDescription)")
                                print("DEBUG: Image URL: \(imageUrl)")
                            }
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                    } else {
                        // URL格式无效
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.orange)
                            Text("图片链接无效")
                                .foregroundColor(.white)
                                .padding(.top)
                        }
                    }
                } else {
                    // 没有头像
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 120))
                            .foregroundColor(.gray)
                        Text("暂无头像")
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                }
                
                Spacer()
            }
        }
        .onTapGesture {
            dismiss()
        }
    }
}

#Preview {
    FullScreenAvatarView()
}
