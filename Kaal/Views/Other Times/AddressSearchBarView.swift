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
                
            }
            
            if ddViewModel.showDropDown && !ddViewModel.results.isEmpty {
                List{
                    ForEach(ddViewModel.results.prefix(6), id: \.self) { result in
                        let displayName = result.displayName ?? ""
                        Button(action: {
                            self.ddViewModel.showDropDown = false
                            self.ddViewModel.searchText = ""
                            self.currentArea = displayName
                            self.savedLat = result.lat ?? ""
                            self.savedLng = result.lon ?? ""
                        }, label: {
                            HStack{
                                Text(displayName)
                                Spacer()
                            }
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    AddressSearchBarView()
}
