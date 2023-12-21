//
//  ChangeAddressView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/20/23.
//

import SwiftUI

struct ChangeAddressView: View {
    @ObservedObject var ddViewModel: AddressDropDownViewModel
     let debounceTime = 1.0
     var debounceTimer: Timer?
    @State var results: [String] = []
    @State var selectedAddress = ""
    var body: some View {
        VStack{
            SearchBar(selectedText: $selectedAddress, text: $ddViewModel.searchTex, showDropdown: $ddViewModel.showDropDown, searchResults: $ddViewModel.searchResults)
        }
    }
}

struct SearchBar: View {
    @Binding var selectedText: String
    @Binding var text: String
    @Binding var showDropdown: Bool
    @Binding var searchResults: [String]

    var body: some View {
        VStack {
            HStack {
                TextField("Search area", text: $text, onEditingChanged: { _ in
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            }
            
            if showDropdown && !searchResults.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(searchResults, id: \.self) { result in
                        Text(result)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            
                            .onTapGesture {
                                self.showDropdown = false
                                self.text = ""
                                
                            }
                    }
                }
               
               
            }
        }
    }
}
#Preview {
    ChangeAddressView(ddViewModel: AddressDropDownViewModel(apiManager: APIManager()))
}
