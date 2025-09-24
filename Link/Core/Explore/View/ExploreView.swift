//
//  ExploreView.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/10.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText: String = ""
    @StateObject private var viewModel = ExploreViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    
    var currentUserId: String {
        UserService.shared.currentUser?.id ?? ""
    }
    
    var displayedUsers: [User] {
        if searchText.isEmpty {
            return isSearchFieldFocused ? [] : viewModel.users.filter { $0.id != currentUserId }
        } else {
            return viewModel.users.filter { user in
                user.username.localizedCaseInsensitiveContains(searchText) ||
                user.fullname.localizedCaseInsensitiveContains(searchText) &&
                user.id != currentUserId
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if displayedUsers.isEmpty {
                        if isSearchFieldFocused {
                            EmptyView()
                        } else if !searchText.isEmpty {
                            Text("No users found")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    } else {
                        ForEach(displayedUsers) { user in
                            NavigationLink(value: user) {
                                UserCell(user: user)
                            }
                            Divider()
                                .padding(.leading, 70)
                                .padding(.vertical, 5)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search")
            
            .navigationDestination(for: User.self) { user in
                ProfileView(user: user)
            }
        }
        .focused($isSearchFieldFocused)
    }
}

#Preview {
    ExploreView()
}

/*    var body: some View {
 NavigationStack {
     ScrollView {
         VStack {
             LazyVStack {
                 ForEach(viewModel.users) { user in
                     NavigationLink(value: user) {
                         UserCell(user: user)
                     }
                     Divider()
                         .padding(.leading, 70)
                         .padding(.vertical, 4)
                 }
             }
         }
     }
     .navigationDestination(for: User.self, destination: { user in
         ProfileView(user: user)
     })
     .navigationTitle("Search")
     .searchable(text: $searchText, prompt: "Search")
 }
}
}
 var filteredUsers: [User] {
     if searchText.isEmpty {
         return []
     } else {
         return viewModel.users.filter { user in
             // 你可以根据用户名、全名或其他字段进行匹配
             user.username.localizedCaseInsensitiveContains(searchText) ||
             user.fullname.localizedCaseInsensitiveContains(searchText)
         }
     }
 }
 */
