//
//  EditProfileModel.swift
//  Link
//
//  Created by KAON SOU on 2025/03/20.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseFirestore

class EditProfileViewModel: ObservableObject {
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    @Published var profileImage: Image?
    private var uiImage: UIImage?
    
    func updateUserData(bio: String) async throws {
        try await updateProfileImage()
        try await updateBio(bio: bio)
    }
    
    @MainActor
    private func loadImage() async {
        guard let item = selectedItem else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    private func updateProfileImage() async throws {
        guard let image = self.uiImage else { return }
        guard let imageUrl = try? await ImageUploader.uploadImage(image) else { return }
        try await UserService.shared.updateUserProfileImage(withImageUrl: imageUrl)
    }
    
    @MainActor
    private func updateBio(bio: String) async throws {
        guard let currentUid = AuthService.shared.userSession?.uid else { return }
        let data: [String: Any] = ["bio": bio]
        try await Firestore.firestore().collection("users").document(currentUid).updateData(data)
        
        if var currentUser = UserService.shared.currentUser {
            currentUser.bio = bio
            UserService.shared.currentUser = currentUser
        }
    }
}
