//
//  User.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/15.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable, Hashable {
    let id: String
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: String?
    var bio: String?
    var followersCount: Int?
}
