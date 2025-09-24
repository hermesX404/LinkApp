//
//  LinkTextModifier.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/08.
//

import SwiftUI

struct LinkTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
            .keyboardType(.asciiCapable)
            .autocapitalization(.none)
    }
}
