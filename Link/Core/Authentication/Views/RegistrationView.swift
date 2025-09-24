//
//  RegistrationView.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/08.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("icon1")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
            
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .modifier(LinkTextFieldModifier())
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(LinkTextFieldModifier())
                
                TextField("Enter your fullname", text: $viewModel.fullname)
                    .modifier(LinkTextFieldModifier())
                
                TextField("Enter your username", text: $viewModel.username)
                    .modifier(LinkTextFieldModifier())
            }
            .frame(width: 350)
            
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text("Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 150, height: 44)
                    .background(.blue)
                    .cornerRadius(8)
                    
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Don't have an account?")
                    
                    Text("Sign Up")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.black)
                .font(.footnote)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    RegistrationView()
}
