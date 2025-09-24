//
//  ActivityView.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/10.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        Text("Nothing to see yet.")
            .foregroundColor(.gray)
        NavigationStack {
            ScrollView {
                LazyVStack {
                    
                }
            }
        }
        .navigationTitle("Activity")
    }
}

#Preview {
    ActivityView()
}
