//
//  AddressSearchView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/26/24.
//

import SwiftUI
import CoreLocation

struct AddressSearchView: View {
    @StateObject var viewModel = AddressSearchViewModel(apiManager: APIManager())
    @ObservedObject var locationManager = LocationManager()
    var completion: (String) -> Void
    var body: some View {
        VStack {
            HStack {
                TextField("Search city", text: $viewModel.searchText, onEditingChanged: { _ in
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
            
            if !viewModel.isNot3Chars {
                DropDownMenuView(){ option in
                    self.viewModel.showDropDown = false
                    self.viewModel.searchText = ""
                    if let lat = Double(viewModel.results[option].lat ?? ""), let lon = Double(viewModel.results[option].lon ?? "") {
                        let location =  CLLocation(latitude: lat, longitude: lon)
                        locationManager.reverseGeocode(location: location){ placemark, error in
                            if let area = placemark?.locality, let country = placemark?.country {
                                let address = "\(area), \(country)"
                                completion(address)
                            }
                        }
                    }
                }.environmentObject(viewModel)
            }
        }
    }
}


