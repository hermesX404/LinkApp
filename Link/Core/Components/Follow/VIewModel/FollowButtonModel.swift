//
//  FollowButtonModel.swift
//  Link
//
//  Created by KAON SOU on 2025/03/24.
//

import Firebase
import FirebaseFirestore

struct FollowButtonModel {
    static func followUser(currentUserId: String, targetUserId: String) async throws {
        let followDoc = Firestore.firestore().collection("follows").document("\(currentUserId)_\(targetUserId)")
        
        try await followDoc.setData([
            "follower": currentUserId,
            "following": targetUserId,
            "followtimestamp": Timestamp(date: Date())
        ])
        
        // 使用原子递增操作更新目标用户的followersCount
        let targetUserRef = Firestore.firestore().collection("users").document(targetUserId)
        try await targetUserRef.updateData([
            "followersCount": FieldValue.increment(Int64(1))
        ])
    }
    
    static func checkIfFollowing(currentUserId: String, targetUserId: String) async throws -> Bool {
        let docRef = Firestore.firestore().collection("follows").document("\(currentUserId)_\(targetUserId)")
        let document = try await docRef.getDocument()
        return document.exists
    }
    
    static func unfollowUser(currentUserId: String, targetUserId: String) async throws {
        let followDoc = Firestore.firestore().collection("follows").document(String("\(currentUserId)_\(targetUserId)"))
        try await followDoc.delete()
        
        let targetUserRef = Firestore.firestore().collection("users").document(targetUserId)
        try await targetUserRef.updateData([
            "followersCount": FieldValue.increment(Int64(-1))
        ])
    }
}
