//
//  FeedVIewModel.swift
//  Link
//
//  Created by KAON SOU on 2025/03/22.
//

import Foundation
import FirebaseFirestore

@MainActor
class FeedViewModel: ObservableObject {
    @Published var links = [Link]()
    private var listener: ListenerRegistration?
    
    init(startListening: Bool = true) {
        Task {
            try? await fetchLinks()
        }
        if startListening {
            listenToLinks()
        }
    }
     
    func fetchLinks() async throws {
        self.links = try await LinkService.fetchLinks()
        print("DEBUG: Fetched \(links.count) links")
        print("DEBUG: Link owner UIDs: \(links.map { $0.ownerUid })")
        try await fetchUserDataForLinks()
    }
    
    private func fetchUserDataForLinks() async throws {
        // 将当前 links 复制到一个常量中，避免并发访问可变变量
        let currentLinks = links
        let count = currentLinks.count
        var results = [Int: User]() // 用来存储任务组中每个任务的结果
        
        await withTaskGroup(of: (Int, User?).self) { group in
            for i in 0..<count {
                let ownerUid = currentLinks[i].ownerUid
                group.addTask {
                    do {
                        let user = try await UserService.fetchUser(withUid: ownerUid)
                        return (i, user)
                    } catch {
                        print("DEBUG: Failed to fetch user data for uid \(ownerUid): \(error.localizedDescription)")
                        return (i, nil)
                    }
                }
            }
            // 收集所有任务的结果到 results 字典中
            for await (i, user) in group {
                if let user = user {
                    results[i] = user
                }
            }
        }
        // 根据 results 创建更新后的数组
        var updatedLinks = currentLinks
        for (i, user) in results {
            updatedLinks[i].user = user
        }
        // 在主线程上更新 Published 属性
        self.links = updatedLinks
    }
    
    func listenToLinks() {
        let db = Firestore.firestore()
        listener = db.collection("links")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener{ [weak self] snapshot, error in
                if let error = error {
                    print("DEBUG: Failed to listen to links: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                let initialLinks = documents.compactMap { try? $0.data(as: Link.self) }

                Task {
                    var updatedLinks = initialLinks

                    await withTaskGroup(of: (Int, User?).self) { group in
                        for (index, link) in updatedLinks.enumerated() {
                            group.addTask {
                                do {
                                    let user = try await UserService.fetchUser(withUid: link.ownerUid)
                                    return (index, user)
                                } catch {
                                    print("DEBUG: Failed to fetch user data for uid \(link.ownerUid): \(error.localizedDescription)")
                                    return (index, nil)
                                }
                            }
                        }
                        
                        for await (i, user) in group {
                            if let user = user {
                                updatedLinks[i].user = user
                            }
                        }
                    }
                    if updatedLinks != self?.links {
                        self?.links = updatedLinks
                    }
                }
            }
    }
    deinit {
        listener?.remove()
    }
    
}
