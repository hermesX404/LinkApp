//
//  Link.swift
//  Link
//
//  Created by KAON SOU on 2025/03/21.
//

import Firebase
import FirebaseFirestore

struct Link: Identifiable, Codable, Equatable {
    @DocumentID var linkId: String?
    let ownerUid: String
    let caption: String
    let timestamp: Timestamp
    var likes: Int
    var commentsCount: Int?
    var location: String?
    
    var id: String {
        return linkId ?? NSUUID().uuidString
    }
    
    var user: User?
}
