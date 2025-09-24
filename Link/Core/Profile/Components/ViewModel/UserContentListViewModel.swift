//
//  UserContentListViewModel.swift
//  Link
//
//  Created by KAON SOU on 2025/03/23.
//

import Foundation
import FirebaseFirestore

@MainActor
class UserContentListViewModel: ObservableObject {
    @Published var links: [Link] = []
    private var listener: ListenerRegistration?
    let user: User
    
    
    init(user: User) {
        self.user = user
        Task {
            await refresh()
        }
        listenToUserLinks()
    }
    
    deinit {
        listener?.remove()
    }
    
    //手动刷新 适用于下拉和和初次加载
    func refresh() async {
        do {
            let fetchedLinks = try await LinkService.fetchUserLinks(uid: user.id)
            self.links = fetchedLinks.map { link in
                var updatedLink = link
                updatedLink.user = self.user
                return updatedLink
            }
        } catch {
            print("DEBUG: Failed to refresh user links: \(error.localizedDescription)")
        }
    }
    
    //监视器 监视点赞状态
    private func listenToUserLinks() {
        listener = Firestore.firestore()
            .collection("links")
            .whereField("ownerUid", isEqualTo: user.id)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("DEBUG: Failed to listen to user links: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                let updatedLinks: [Link] = documents.compactMap {
                    var link = try? $0.data(as: Link.self)
                    link?.user = self.user
                    return link
                }
                
                self.links = updatedLinks
            }
    }
    
}
