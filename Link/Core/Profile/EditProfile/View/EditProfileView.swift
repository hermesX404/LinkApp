//
//  EditProfileView.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/11.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    let user: User
    @State private var bio = ""
    @State private var Interest = ""
    @State private var isPrivateProfile = false
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = EditProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Name")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("\(user.fullname) (\(user.email))")
                                .font(.callout)
                                .foregroundStyle(.blue)
                        }
                        .padding(.top, 10)
                        .font(.footnote)
                        Spacer()
                        
                        PhotosPicker(selection: $viewModel.selectedItem) {
                            if let image = viewModel.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .clipShape(Circle())
                            } else {
                                CircularProfileImageView(user: user, size: 60)
                            }
                        }
                    }
                    Divider()
                        .padding(.trailing, 70)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Bio")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 7)
                        TextField("+ Write bio", text: $bio, axis: .vertical)
                            .font(.callout)
                    }
                    .font(.footnote)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Interest")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 7)
                        TextField("+ Add Interest", text: $Interest)
                            .font(.callout)
                    }
                    .font(.footnote)
                    
                    Divider()
                    
                    VStack(spacing: 3) {
                        Toggle("Private profile", isOn: $isPrivateProfile)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("If you swith to public, anyone can see your link and replies.")
                            .foregroundStyle(Color(.gray))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .font(.footnote)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
                .padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.bio = user.bio ?? ""
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        Task {
                            try await viewModel.updateUserData(bio: bio)
                            dismiss()
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                }
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: dev.user)
    }
}
