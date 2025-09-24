//
//  LinkService.swift
//  Link
//
//  Created by KAON SOU on 2025/03/21.
//

import Foundation
import Firebase
import FirebaseFirestore


struct LinkService {
    
    static func uploadLink(_ link: Link) async throws {
        guard let linkData = try? Firestore.Encoder().encode(link) else { return }
        try await Firestore.firestore().collection("links").addDocument(data: linkData)
    }
    
    static func fetchLinks() async throws -> [Link] {
        let snapshot = try await Firestore
            .firestore()
            .collection("links")
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Link.self)})
    }
    
    static func fetchUserLinks(uid: String) async throws -> [Link] {
        let snapshot = try await Firestore
            .firestore()
            .collection("links")
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        
        let links = snapshot.documents.compactMap({ try? $0.data(as: Link.self) })
        return links.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
    
}
