//
//  Loginview.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/08.
//

import SwiftUI

struct Loginview: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var keyboardHeight: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(colorScheme == .dark ? "icon1_dark" : "icon1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
                    .padding(.vertical, 30)
                
                VStack {
                    TextField("Enter your email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(LinkTextFieldModifier())
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .modifier(LinkTextFieldModifier())
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                }
                .frame(width: 350, height: 44)
                
                HStack {
                    Spacer()
                    NavigationLink {
                        Text("Forgot password")
                    } label: {
                        Text("Forgot password?")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                            .padding(.vertical, 10)
                            .frame(minWidth: 60, minHeight: 1)
                    }
                    .padding(.vertical, 10)
                    .padding(.trailing, 40)
                }
                
                Button(action: {
                    Task {
                        await viewModel.login()
                        if let error = viewModel.errorMessage {
                            print("Login failed: \(error)")
                        } else {
                            print("Login successful")
                        }
                    }
                }) {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 44)
                        .background(.blue)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        
                        Text("Sign up")
                    }
                    .foregroundStyle(.blue)
                    .font(.footnote)
                }
                .padding(.vertical, 10)
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .alert("Login Failed", isPresented: $viewModel.showErrorAlert, presenting: viewModel.errorMessage) { error in
                Button("OK", role: .cancel) { }
            } message: { error in
                Text(error)
            }
        }
    }
}

#Preview {
    Loginview()
}

/*
 .animation(.easeOut(duration: 0.8), value: keyboardHeight)private func setupKeyboardObservers() {
 NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
     if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
         keyboardHeight = keyboardFrame.height / 1.5 // 适当调整
     }
 }
 
 NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
     keyboardHeight = 0
 }
}*/
