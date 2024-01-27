    //
    //  AddressSearchBarView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/23/23.
    //

import SwiftUI
import CoreLocation

struct AddressSearchBarView: View {
    @EnvironmentObject var ddViewModel:  AddressSearchViewModel
    @EnvironmentObject var locationManager: LocationManager
    @AppStorage("savedLat") var savedLat = ""
    @AppStorage("savedLong") var savedLng = ""
    @AppStorage("currentArea") var currentArea: String = ""
    var completion: () -> Void
    var body: some View {
        
        VStack(spacing: 4){
            HStack {
                TextField("Search city", text: $ddViewModel.searchText, onEditingChanged: { _ in
                })
                .textFieldStyle(.plain)
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(8)
            }.overlay {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(.primary.opacity(0.5), lineWidth: 1)
                    .padding(.horizontal)
            }
            
            if !ddViewModel.isNot3Chars {
                DropDownMenuView(){ option in
                    self.ddViewModel.showDropDown = false
                    self.ddViewModel.searchText = ""
                    
                    if let lat = Double(ddViewModel.results[option].lat ?? ""), let lon = Double(ddViewModel.results[option].lon ?? "") {
                        let location =  CLLocation(latitude: lat, longitude: lon)
                        self.savedLat = ddViewModel.results[option].lat ?? ""
                        self.savedLng = ddViewModel.results[option].lon ?? ""
                        self.currentArea = ddViewModel.results[option].displayName ?? ""
                        locationManager.reverseGeocode(location: location){ placemark, error in
                            if let area = placemark?.locality, let country = placemark?.country {
                                self.currentArea = "\(area), \(country)"
                            }
                        }
                    }
                    completion()
                }.environmentObject(ddViewModel)
                
            }
        }.padding(.bottom)
    }
}

#Preview {
    AddressSearchBarView(){
        print("Hello")
    }
}
