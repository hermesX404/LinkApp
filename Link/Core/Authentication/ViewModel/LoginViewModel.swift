//
//  LoginViewModel.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/15.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    
    @MainActor
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Email and password cannot be empty."
            self.showErrorAlert = true
            return
        }
        
        do {
            try await AuthService.shared.login(withEmail: email, password: password)
        } catch let error as NSError {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
            }
        }
    }
}
