//
//  PreviewProvider.swift
//  Link
//
//  Created by KAON SOU on 2025/03/19.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    
    static var shared = DeveloperPreview()
    
    let user = User(
        id: NSUUID().uuidString,
        fullname: "Max Verstappen",
        email: "max@gmail.com",
        username: "maxverstappen1",
        profileImageUrl: nil,
        bio: "Racing driver",
        followersCount: 1000
    )
    
    let link = Link(
        linkId: NSUUID().uuidString,
        ownerUid: "123",
        caption: "This is a test link",
        timestamp: Timestamp(),
        likes: 0,
        location: "Tokyo"
    )
    
    lazy var comment = Comment(
        commentId: NSUUID().uuidString,
        userId: "123",
        content: "This is a comment",
        likes: 0,
        timestamp: Timestamp(),
        user: self.user
    )
}
