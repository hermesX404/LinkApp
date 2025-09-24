//
//  LinkTabView.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/10.
//

import SwiftUI

struct LinkTabView: View {
    @State private var selectedTab = 0
    @State private var showCreateLinkView = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .onAppear { selectedTab = 1 }
                .tag(1)
            
            Text("")
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "plus.rectangle.fill" : "plus.rectangle")
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
            
            ActivityView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
            
            CurrentUserProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                }
                .onAppear { selectedTab = 4 }
                .tag(4)
            
        }
        .onChange(of: selectedTab) { oldvalue, newValue in
            if newValue == 2 {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                showCreateLinkView = true
            } else {
                showCreateLinkView = false
            }
        }
        .sheet(isPresented: $showCreateLinkView, onDismiss: {
            selectedTab = 0
        }, content: {
            CreateLinkView()
        })
        .tint(Color(hue: 0.612, saturation: 0.612, brightness: 0.909))
    }
}

#Preview {
    LinkTabView()
}
