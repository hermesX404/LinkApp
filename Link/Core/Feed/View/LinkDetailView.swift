//
//  LinkDetailView.swift
//  Link
//
//  Created by KAON SOU on 2025/03/31.
//

import SwiftUI
import FirebaseFirestore

struct LinkDetailView: View {
    let link: Link
    @StateObject private var viewModel: LinkDetailViewModel
    @FocusState private var isCommentFieldFocused: Bool
    var autoFocusCommentField: Bool

    var currentUser: User? {
        UserService.shared.currentUser
    }
    init(link: Link, autoFocusCommentField: Bool = false) {
        self.link = link
        self.autoFocusCommentField = autoFocusCommentField
        _viewModel = StateObject(wrappedValue: LinkDetailViewModel(link: link))
    }
    
    @State private var showOptionsMenue = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HStack(alignment: .top, spacing: 12) {
                        CircularProfileImageView(user: link.user)
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                // 显示用户名
                                Text(link.user?.fullname ?? "Unknown User")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                                    .padding(.vertical, 8)
                                
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
                            }
                            
                            //显示帖子内容
                            Text(link.caption)
                                .foregroundColor(.primary)
                                .font(.headline)
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .padding(.vertical, 5)
                            
                            
                            //与帖子互动选项
                            HStack(spacing: 20) {
                                
                                LikeButtonView(link: link, currentUserId: AuthService.shared.userSession?.uid ?? "", targetUserId: link.ownerUid)
                                
                                HStack(spacing: 2) {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "bubble.right")
                                    }
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
                    VStack(alignment: .leading) {
                        Text("Replies")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.leading, -208)
                    }
                    Divider()
                    
                    LazyVStack {
                        ForEach(viewModel.comments) { comment in
                            CommentCell(comment: comment)
                            Divider()
                        }
                    }
                }
                .padding(9)
                .overlay (
                    Group {
                        if showToast {
                            ToastView(message: toastMessage)
                                .transition(.opacity)
                                .zIndex(1)
                                .offset(y: 400)
                        }
                    },
                    alignment: .center
                )
            }
            Divider()
            
            // 添加评论
            HStack {
                TextField("Add a comment...", text: $viewModel.commentText, axis: .vertical)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                    .focused($isCommentFieldFocused)
                
                Button {
                    Task {
                        if let currentUser = UserService.shared.currentUser {
                            await viewModel.addComment(currentUser: currentUser)
                        }
                    }
                } label: {
                    Text("Post")
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                }
                .disabled(viewModel.commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .navigationTitle("Link")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showOptionsMenue.toggle()
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(.primary)
                        
                    }
                }
            }
            .sheet(isPresented: $showOptionsMenue, content: {
                OptionsMenueView(onOptionSelected: { message in
                    showToastWithDelay()
                    toastMessage = message
                })
                .presentationDetents([.height(320)])
                .presentationDragIndicator(.visible)
            })
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isCommentFieldFocused = true
            }
        }
    }
    private func showToastWithDelay() {
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
}


#Preview {
    NavigationStack {
        LinkDetailView(link: DeveloperPreview.shared.link)
    }
}
