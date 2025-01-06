//
//  SearchBarView.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 05/01/2025.
//
import SwiftUI

struct SearchBar: View {
    var placeholder: String
    @Binding var text: String
    @State private var isEditing = false
    @FocusState private var textFieldFocused: Bool
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .font(.system(size: 14))
                .padding(10)
                .padding(.horizontal, 25)
                .background(Color(.white))
                .cornerRadius(10)
                .padding(.horizontal, 10)
                .keyboardType(.default)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .focused($textFieldFocused)
                .onTapGesture {
                    isEditing = true
                }.overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                        if isEditing {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 16)
                            }
                        }
                    }
                )
            Button(action: {
                isEditing = false
                text = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                Text("Cancel")
            }
            .padding(.trailing, 10)
        }.padding(.horizontal, 10)
    }
}
