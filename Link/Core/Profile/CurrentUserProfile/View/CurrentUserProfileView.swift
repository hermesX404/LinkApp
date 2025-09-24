//
//  CurrentUserProfileView.swift
//  Link
//
//  Created by KAON SOU on 2025/03/19.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @StateObject var viewModel = CurrentUserProfileViewModel()
    @State private var showEditProfile = false
    @State private var showShareProfile = false
    
    private var currentUser: User? {
#if DEBUG
        return viewModel.currentUser ?? DeveloperPreview.shared.user
#else
        return viewModel.currentUser
#endif
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ProfileHeaderView(user: currentUser)
                
                HStack {
                    Button {
                        showEditProfile.toggle()
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .frame(width: 200, height: 32)
                            .background(.white)
                            .cornerRadius(8)
                            .overlay {
                                (RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1))
                            }
                    }
                    
                    Button {
                        showShareProfile.toggle()
                    } label: {
                        Text("Share Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .frame(width: 200, height: 32)
                            .background(.white)
                            .cornerRadius(8)
                            .overlay {
                                (RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1))
                            }
                    }
                }
                
                if let user = currentUser {
                    UserContentListView(user: user)
                } else {
                    Text("Loading user data...")
                        .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $showEditProfile, content: {
                if let user = currentUser {
                    EditProfileView(user: user)
                }
            })
            
            .sheet(isPresented: $showShareProfile, content: {
                if let user = currentUser {
                    ShareProfileView(user: user)
                        .presentationDetents([.height(500)])
                        .presentationDragIndicator(.visible)
                }
            })
            
            //sign out button
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        AuthService.shared.signOut()
                    } label: {
                        Image(systemName: "globe.badge.chevron.backward")
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    CurrentUserProfileView()
}
