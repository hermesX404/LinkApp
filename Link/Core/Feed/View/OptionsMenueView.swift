//
//  OptionsMenueView.swift
//  Link
//
//  Created by KAON SOU on 2025/03/31.
//

import SwiftUI

struct OptionsMenueView: View {
    @Environment(\.dismiss) var dismiss
    var onOptionSelected: (String) -> Void
    
    var body: some View {
        ZStack {
            Color(red: 0.957, green: 0.957, blue: 0.957)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Button(action: {
                    onOptionSelected("Translation option selected")
                    dismiss()
                }) {
                    HStack(spacing: 220) {
                        Text("See translation")
                            .font(.headline)
                            .fontWeight(.regular)
                        Image(systemName: "translate")
                            .font(.title2)
                    }
                    .foregroundColor(.black)
                    .frame(width: 400, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                }
                Button(action: {
                    onOptionSelected("Saved")
                    dismiss()
                }) {
                    HStack(spacing: 310) {
                        Text("Save")
                            .font(.headline)
                            .fontWeight(.regular)
                        Image(systemName: "bookmark")
                            .font(.title2)
                    }
                    .foregroundColor(.black)
                    .frame(width: 400, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                Button(action: {
                    onOptionSelected("You will see fewer posts like this.")
                    dismiss()
                }) {
                    HStack(spacing: 230) {
                        Text("Not interested")
                            .font(.headline)
                            .fontWeight(.regular)
                        Image(systemName: "eye.slash")
                            .font(.title2)
                    }
                    .foregroundColor(.black)
                    .frame(width: 400, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                Button(action: {
                    onOptionSelected("User has been Blocked.")
                    dismiss()
                }) {
                    HStack(spacing: 300) {
                        Text("Block")
                            .foregroundStyle(.red)
                            .font(.headline)
                            .fontWeight(.regular)
                        Image(systemName: "person.slash")
                            .font(.title2)
                            .foregroundStyle(.red)
                    }
                    .foregroundColor(.black)
                    .frame(width: 400, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                Button(action: {
                    onOptionSelected("The Link has been Reported.")
                    dismiss()
                }) {
                    HStack(spacing: 290) {
                        Text("Report")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundStyle(.red)
                        Image(systemName: "exclamationmark.bubble")
                            .font(.title2)
                            .foregroundStyle(.red)
                    }
                    .foregroundColor(.black)
                    .frame(width: 400, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
        }
    }
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.callout)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.bottom, 50)
    }
}

struct OptionsMenueView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsMenueView(onOptionSelected: { message in
            print("Option selected: \(message)")
        })
        .previewLayout(.sizeThatFits)
    }
}
