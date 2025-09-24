//
//  ExploreViewModel.swift
//  Link
//
//  Created by KAON SOU on 2025/03/19.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestore

class ExploreViewModel: ObservableObject {
    @Published var users = [User]()
    private var listener: ListenerRegistration?
    
    
    init() {
        fetchUsersRealtime()
    }
    
    func fetchUsersRealtime() {
        let db = Firestore.firestore()
        listener = db.collection("users")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("DEBUG: Failed to fetch users: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                // 将文档解码为 User 对象
                self?.users = documents.compactMap { try? $0.data(as: User.self) }
            }
    }
    
    deinit {
        listener?.remove()
    }
}


/*init() {
 Task { try await fetchUsers() }
}

@MainActor
private func fetchUsers() async throws {
 self.users = try await UserService.fetchUsers()
}*/
