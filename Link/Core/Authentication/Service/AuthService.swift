//
//  AuthService.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/14.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage: String?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await UserService.shared.fetchCurrentUser()
        } catch {
            throw handleAuthError(error)
        }
    }
        
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await uploadUserData(withEmail: email, fullname: fullname, username: username, id: result.user.uid)
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            UserService.shared.reset()
            print("DEBUG: User is signed out")
        } catch {
            print("DEBUG: Failed to sign out: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func uploadUserData(
        withEmail email: String,
        fullname: String,
        username: String,
        id: String
    ) async throws{
        let user = User(id: id, fullname: fullname, email: email, username: username)
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(userData)
        UserService.shared.currentUser = user
    }
    
    private func handleAuthError(_ error: Error) -> NSError {
        let nsError = error as NSError
        guard let errorCode = AuthErrorCode(_bridgedNSError: nsError) else {
            return NSError(domain: "", code: nsError.code, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred."])
        }
        
        let errorMsg: String
        
        switch errorCode.code {
        case .invalidEmail:
            errorMsg = "Invalid email format. Please enter a valid email."
        case .wrongPassword:
            errorMsg = "Incorrect password. Please try again."
        case .userNotFound:
            errorMsg = "User not found. Please check your email or register first."
        case .networkError:
            errorMsg = "Network error. Please check your internet connection."
        case .tooManyRequests:
            errorMsg = "Too many failed attempts. Please try again later."
        default:
            errorMsg = "Login failed: \(error.localizedDescription)"
        }
        
        return NSError(domain: "", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: errorMsg])
    }
}
