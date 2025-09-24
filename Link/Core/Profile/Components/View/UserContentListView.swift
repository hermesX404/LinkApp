//
//  UserContentListView.swift
//  Link
//
//  Created by KAON SOU on 2025/03/20.
//

import SwiftUI
import Firebase

struct UserContentListView: View {
    @StateObject var viewModel: UserContentListViewModel
    @State private var selectedFilter: ProfileLinkFilter = .links
    @Namespace var animation
    
    private var filterBarwidth: CGFloat {
        let count = CGFloat(ProfileLinkFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 16
    }
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: UserContentListViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(ProfileLinkFilter.allCases) { filter in
                    VStack {
                        Text(filter.title)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == filter ? .semibold : .regular)
                            .foregroundStyle(selectedFilter == filter ? Color.black : Color(UIColor.systemGray4))
                            .frame(maxWidth: .infinity)
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(UIColor.systemGray4))
                                .frame(height: 1)
                            if selectedFilter == filter {
                                Rectangle()
                                    .foregroundColor(.black)
                                    .frame(height: 1)
                                    .matchedGeometryEffect(id: "indicator", in: animation)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.1)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .id(selectedFilter)
            .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.1), value: selectedFilter)
            
            
            TabView(selection: $selectedFilter) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.links) { link in
                            LinkCell(link: link)
                        }
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }
                .tag(ProfileLinkFilter.links)
                
                ScrollView {
                    LazyVStack {
                        ForEach(1..<11) { index in
                            Text("Reply #\(index)")
                                .padding()
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                }
                .tag(ProfileLinkFilter.replies)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .onAppear {
            Task {
                await viewModel.refresh()
            }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: .linkLiked)) { _ in
            Task {
                await viewModel.refresh()
            }
        }
        .padding(.vertical, 8)
    }
}

struct userContenListView_Previews: PreviewProvider {
    static var previews: some View {
        UserContentListView(user: dev.user)
    }
}

/*
 import SwiftUI
 import Firebase

 struct UserContentListView: View {
     @StateObject var viewModel: UserContentListViewModel
     @State private var selectedFilter: ProfileLinkFilter = .links
     @Namespace var animation
     
     private var filterBarwidth: CGFloat {
         let count = CGFloat(ProfileLinkFilter.allCases.count)
         return UIScreen.main.bounds.width / count - 16
     }
     
     init(user: User) {
         self._viewModel = StateObject(wrappedValue: UserContentListViewModel(user: user))
     }
     
     var body: some View {
         VStack {
             HStack {
                 ForEach(ProfileLinkFilter.allCases) { filter in
                     VStack {
                         Text(filter.title)
                             .font(.subheadline)
                             .fontWeight(selectedFilter == filter ? .semibold : .regular)
                         
 if selectedFilter == filter {
     Rectangle()
         .foregroundStyle(.black)
         .frame(width: filterBarwidth, height: 1)
         .matchedGeometryEffect(id: "item", in: animation)
 } else {
     Rectangle()
         .foregroundStyle(.gray)
         .frame(width: filterBarwidth, height: 1)
 }
                     }
                     .onTapGesture {
                         withAnimation(.spring()) {
                             selectedFilter = filter
                         }
                     }
                 }
             }
             LazyVStack {
                 ForEach(viewModel.links) { link in
                     LinkCell(link: link)
                 }
             }
         }
         .padding(.vertical, 8)
     }
 }

 struct userContenListView_Previews: PreviewProvider {
     static var previews: some View {
         UserContentListView(user: dev.user)
     }
 }
 */
