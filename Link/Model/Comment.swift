//
//  Comment.swift
//  Link
//
//  Created by KAON SOU on 2025/03/31.
//

import Firebase
import FirebaseFirestore

struct Comment: Identifiable, Codable, Equatable {
    @DocumentID var commentId: String?
    let userId: String
    let content: String
    var likes: Int
    let timestamp: Timestamp
    var id: String {
        commentId ?? UUID().uuidString
    }
    var user: User?
}
