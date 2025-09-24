//
//  ProfileLinkFilter.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/11.
//

import Foundation

enum ProfileLinkFilter: Int, CaseIterable, Identifiable {
    case links
    case replies
    
    var title: String {
        switch self {
        case .links: return "Link"
        case .replies: return "Replies"
        }
    }
    
    var id: Int { return self.rawValue }
}
