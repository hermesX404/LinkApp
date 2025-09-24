//
//  LinkDetailViewModel.swift
//  Link
//
//  Created by KAON SOU on 2025/03/31.
//

import Foundation
import FirebaseFirestore

@MainActor
class LinkDetailViewModel: ObservableObject {
    @Published var link: Link
    @Published var comments: [Comment] = []
    @Published var commentText: String = ""

    
    private var commentsListener: ListenerRegistration?
    
    init(link: Link) {
        self.link = link
        Task {
            await fetchComments()
        }
        listenToComments()
    }
    
    deinit {
        commentsListener?.remove()
    }
    
    // MARK: - Fetch Comments
    func fetchComments() async {
        do {
            let snapshot = try await Firestore.firestore()
                .collection("links")
                .document(link.id)
                .collection("comments")
                .order(by: "timestamp", descending: false)
                .getDocuments()
            
            var fetchedComments = snapshot.documents.compactMap { try? $0.data(as: Comment.self) }
            
            try await fetchUsersForComments(&fetchedComments)
            
            self.comments = fetchedComments
            
        } catch {
            print("Failed to fetch comments: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Listen to Comments Realtime
    func listenToComments() {
        commentsListener = Firestore.firestore()
            .collection("links")
            .document(link.id)
            .collection("comments")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                Task {
                    var updatedComments = documents.compactMap { try? $0.data(as: Comment.self) }
                    try await self?.fetchUsersForComments(&updatedComments)
                    await MainActor.run {
                        self?.comments = updatedComments
                    }
                }
            }
    }
    
    // MARK: - Fetch Users for Comments
    private func fetchUsersForComments(_ comments: inout [Comment]) async throws {
        await withTaskGroup(of: (Int, User?).self) { group in
            for (index, comment) in comments.enumerated() {
                group.addTask {
                    do {
                        let user = try await UserService.fetchUser(withUid: comment.userId)
                        return (index, user)
                    } catch {
                        print("DEBUG: Failed to fetch user data for comment uid \(comment.userId): \(error.localizedDescription)")
                        return (index, nil)
                    }
                }
            }
            
            for await (index, user) in group {
                if let user = user {
                    comments[index].user = user
                }
            }
        }
    }
    
    // MARK: - Add a Comment
    func addComment(currentUser: User) async {
        guard !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Comment text is empty.")
            return
        }
        do {
            let commentRef = Firestore.firestore()
                .collection("links")
                .document(link.id)
                .collection("comments")
                .document()
            
            let newComment = Comment(
                commentId: commentRef.documentID,
                userId: currentUser.id,
                content: commentText,
                likes: 0,
                timestamp: Timestamp(date: Date()),
                user: currentUser
            )
            
            try commentRef.setData(from: newComment)
            commentText = ""
            await fetchComments()
            
            // 评论数量增加
            try await Task.detached(priority: .userInitiated) {
                try commentRef.setData(from: newComment)
                try await Firestore.firestore().collection("links").document(self.link.id).updateData([
                    "commentsCount": FieldValue.increment(Int64(1))
                ])
            }.value
            
            
        } catch {
            print("Failed to add comment: \(error.localizedDescription)")
        }
    }

    // MARK: - Delete a Comment
    func deleteComment(_ comment: Comment) async {
        guard let commentId = comment.commentId else { return }
        do {
            try await Firestore.firestore()
                .collection("links")
                .document(link.id)
                .collection("comments")
                .document(commentId)
                .delete()
            
        } catch {
            print("Failed to delete comment: \(error.localizedDescription)")
        }
    }
}
