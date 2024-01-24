    //
    //  AddressSearchBarView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/23/23.
    //

import SwiftUI

struct AddressSearchBarView: View {
    @EnvironmentObject var ddViewModel:  AddressSearchViewModel
    @AppStorage("savedLat") var savedLat = ""
    @AppStorage("savedLong") var savedLng = ""
    @AppStorage("currentArea") var currentArea: String = ""
    var body: some View {
        
        VStack{
            HStack {
                TextField("Search area", text: $ddViewModel.searchText, onEditingChanged: { _ in
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.primary)
                .padding(.horizontal)
                .overlay {
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(.primary.opacity(0.5), lineWidth: 2)
                        .padding(.horizontal)
                }
                
            }
            
            if ddViewModel.showDropDown && !ddViewModel.results.isEmpty {
                DropDownMenuView(){ option in
                    self.ddViewModel.showDropDown = false
                    self.ddViewModel.searchText = ""
                    self.currentArea = ddViewModel.results[option].displayName ?? ""
                    self.savedLat = ddViewModel.results[option].lat ?? ""
                    self.savedLng = ddViewModel.results[option].lon ?? ""
                }
              
            }
        }
    }
}

#Preview {
    AddressSearchBarView()
}
