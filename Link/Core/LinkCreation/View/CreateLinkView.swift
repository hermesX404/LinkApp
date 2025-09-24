//
//  CreatLink.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/10.
//

import SwiftUI

struct CreateLinkView: View {
    @StateObject var viewModel = CreateLinkViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var useCurrentLocation: Bool = false
    @State private var caption = ""
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFiledFocused: Bool

    private var user: User? {
        return UserService.shared.currentUser
    }
    
    var body: some View {
        NavigationStack {
            Divider()
            VStack {
                HStack(alignment: .top) {
                    CircularProfileImageView(user: user, size: 50)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(user?.fullname ?? "Unknown User")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                        
                        //显示用户位置
                        if useCurrentLocation && !locationManager.locationName.isEmpty {
                            HStack(spacing: 20) {
                                Text(locationManager.locationName)
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                            }
                        }
                        
                        TextField("Start a Link...", text: $caption, axis: .vertical)
                            .font(.title3)
                            .fontWeight(.regular)
                            .padding(.vertical, 5)
                            .focused($isTextFiledFocused)
                        
                        //设置位置按钮获取用户位置
                        HStack(alignment: .center, spacing: 5) {
                            Button {
                                useCurrentLocation.toggle()
                                if useCurrentLocation {
                                    locationManager.startUpdating()
                                } else {
                                    locationManager.stopUpdating()
                                }
                            } label: {
                                if useCurrentLocation {
                                    HStack(spacing: 3) {
                                        Image(systemName: "location.circle.fill")
                                            .foregroundStyle(.blue)
                                            .font(.title)
                                        Text("The current location has been obtained")
                                            .foregroundStyle(.blue)
                                            .font(.subheadline)
                                    }
                                } else {
                                    Image(systemName: "location.circle")
                                        .foregroundStyle(.gray)
                                        .font(.title)
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.vertical, 15)
                            .padding(.horizontal, -9)
                        }
                    }
                    Spacer()
                    
                    //清除输入框
                    if !caption.isEmpty {
                        Button {
                            caption = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                Spacer()
            }
            .animation(.spring(duration: 0.4), value: locationManager.locationName)
            .padding()
            .navigationTitle("New Link")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                DispatchQueue.main.async() {
                    isTextFiledFocused = true
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.callout)
                    .foregroundStyle(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        Task {
                            do {
                                try await viewModel.uploadLink(
                                    caption: caption,
                                    location: useCurrentLocation ? locationManager.userLocation : nil)
                                NotificationCenter.default.post(name: .linkPosted, object: nil)
                                dismiss()
                            } catch {
                                print("Error uploading link: \(error.localizedDescription)")
                            }
                        }
                    }
                    //????????
                    .disabled(caption.isEmpty || (useCurrentLocation && locationManager.userLocation == nil))
                    .opacity(caption.isEmpty ? 0.5 : 1.0)
                    .disabled(caption.isEmpty)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                }
            }
        }
    }
}

struct CreateLinkView_Preview: PreviewProvider {
    static var previews: some View {
        CreateLinkView()
    }
}
