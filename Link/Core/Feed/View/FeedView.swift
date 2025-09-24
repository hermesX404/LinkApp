//
//  FeedView.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/10.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    if viewModel.links.isEmpty {
                        Text("No posts yet")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(viewModel.links) { link in
                            NavigationLink(destination: LinkDetailView(link: link)) {
                                LinkCell(link: link)
                            }
                        }
                    }
                }
            }
            .refreshable {
                Task { try await viewModel.fetchLinks()}
            }
            .onReceive(NotificationCenter.default.publisher(for: .linkPosted)) { _ in
                Task {
                    try await viewModel.fetchLinks()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(systemName: "atom")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                }
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FeedView()
        }
    }
}
