//
//  UserService.swift
//  Link
//
//  Created by KAON SOU on 2025/03/19.
//
import FirebaseAuth
import FirebaseFirestore

class UserService {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    init() {
        Task { try await fetchCurrentUser()}
    }
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    static func fetchUsers() async throws -> [User] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self)})
        return users.filter({ $0.id != currentUid })
    }
    
    static func fetchUser(withUid uid: String) async throws -> User {
        print("DEBUG: Fetching user with UID: \(uid)")
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        
        guard snapshot.exists else {
            print("DEBUG: User document does not exist for UID: \(uid)")
            throw NSError(domain: "UserService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        let user = try snapshot.data(as: User.self)
        print("DEBUG: Successfully fetched user: \(user.fullname) for UID: \(uid)")
        return user
    }
    
    
    func reset() {
        self.currentUser = nil
    }
    
    @MainActor
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let data: [String: String] = ["profileImageUrl": imageUrl]
        try await Firestore.firestore().collection("users").document(currentUid).updateData(data)
        self.currentUser?.profileImageUrl = imageUrl
    }
}

