    //
    //  ChangeAddressView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/20/23.
    //

import SwiftUI

struct ChangeAddressView: View {
    @AppStorage("savedLat") var savedLat = ""
    @AppStorage("savedLong") var savedLng = ""
    @AppStorage("currentArea") var currentArea: String = ""
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var ddViewModel: AddressSearchViewModel
  
  
    var body: some View {
        Form {
            HStack {
                TextField("Search area", text: $ddViewModel.searchText, onEditingChanged: { _ in
                }).padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.primary)
                
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
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            HStack{
                                Text(displayName)
                                Spacer()
                            }
                            
                        })
                        
                    }
                }
            }
            Spacer()
        }
    }
}


#Preview {
    ChangeAddressView(ddViewModel: AddressSearchViewModel(apiManager: APIManager()))
}
