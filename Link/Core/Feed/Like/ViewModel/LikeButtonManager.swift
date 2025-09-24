//
//  LlikeButtonModel.swift
//  Link
//
//  Created by KAON SOU on 2025/03/25.
//

import Foundation
import FirebaseFirestore

struct LikeButtonManager {
    
    static func updateLikes(for link: Link,currentUserId: String, targetUserId: String, increment: Bool) async throws {

        guard let linkId = link.linkId else { return }
        let db = Firestore.firestore()
        
        //更新帖子点赞数
        let delta = increment ? 1 : -1
        try await db.collection("links").document(linkId).updateData([
            "likes": FieldValue.increment(Int64(delta))
        ])
        
        //更新点赞记录
        let likeDoc = db.collection("likes").document("\(currentUserId)_\(linkId)")
        if increment {
            try await likeDoc.setData([
                "userId": currentUserId,
                "targetUserId": targetUserId,
                "linkId": linkId,
                "timestamp": Timestamp(date: Date())
            ])
        } else {
            try await likeDoc.delete()
        }
    }
    
    //检查点赞状态
    static func checkIfLiked(for link: Link, currentUserId: String) async throws -> Bool {
        guard let linkId = link.linkId else { return false }
        let db = Firestore.firestore()
        let doc = try await db.collection("likes").document("\(currentUserId)_\(linkId)").getDocument()
        return doc.exists
    }
}
