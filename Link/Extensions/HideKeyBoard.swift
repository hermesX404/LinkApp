//
//  hideKeyBoard.swift
//  Link
//
//  Created by KAON SOU on 2025/03/18.
//

import Foundation

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
