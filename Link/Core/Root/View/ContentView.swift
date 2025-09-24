//
//  ContentView.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/08.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                LinkTabView()
            } else {
                Loginview()
            }
        }
    }
}

#Preview {
    ContentView()
}
