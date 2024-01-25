    //
    //  ChangeAddressView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/20/23.
    //

import SwiftUI
import CoreLocation

struct ChangeAddressView: View {
    @AppStorage("savedLat") var savedLat = ""
    @AppStorage("savedLong") var savedLng = ""
    @AppStorage("currentArea") var currentArea: String = ""
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var ddViewModel = AddressSearchViewModel(apiManager: APIManager())
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            Button(action: {
                if let location = locationManager.handleLocation() {
                    savedLat =  locationManager.exposedLocation?.coordinate.latitude.description ?? ""
                    savedLng =  locationManager.exposedLocation?.coordinate.longitude.description ?? ""
                    
                    locationManager.reverseGeocode(location: location){ placemark, error in
                        if let area = placemark?.locality, let country = placemark?.country {
                            self.currentArea = "\(area), \(country)"
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    locationManager.askPermission()
                }
            }, label: {
                HStack{
                    Spacer()
                    Text("Get address from your current location")
                    Spacer()
                }
            }).buttonStyle(.bordered)
                .padding(.horizontal)
            
            HStack{
                Spacer()
                Text("Or").padding()
                Spacer()
            }
            
            HStack {
                TextField("Search city", text: $ddViewModel.searchText, onEditingChanged: { _ in
                })
                .textFieldStyle(.plain)
                .foregroundColor(.primary)
                .padding(8)
                
                Button(action: {
                    ddViewModel.callAPI(text: ddViewModel.searchText)
                }, label: {
                    Image(systemName: "location.magnifyingglass")
                        .foregroundColor((ddViewModel.searchText.isEmpty && ddViewModel.isNot3Chars) ? .white : .primary)
                        .padding(.horizontal, 8)
                })
                .disabled(ddViewModel.searchText.isEmpty && ddViewModel.isNot3Chars)
            }
            .padding(.horizontal)
            .overlay {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(.primary.opacity(0.5), lineWidth: 2)
                    .padding(.horizontal)
            }
            
            if !ddViewModel.isNot3Chars {
                DropDownMenuView() { option in
                    let result = ddViewModel.results[option]
                    self.ddViewModel.showDropDown = false
                    self.ddViewModel.searchText = ""
                    if let lat = Double(result.lat ?? ""), let lon = Double(result.lon ?? "") {
                        let location =  CLLocation(latitude: lat, longitude: lon)
                        self.savedLat = result.lat ?? ""
                        self.savedLng = result.lon ?? ""
                        self.currentArea = result.displayName ?? ""
                        locationManager.reverseGeocode(location: location){ placemark, error in
                            if let area = placemark?.locality, let country = placemark?.country {
                                self.currentArea = "\(area), \(country)"
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }.environmentObject(ddViewModel)
            }
            
            Spacer()
            
        }.onChange(of: locationManager.permissionGiven) { oldValue, newValue in
            if newValue != oldValue {
                updateLocation()
            }
        }
    }
    
    func updateLocation(){
        if let location = locationManager.handleLocation() {
            savedLat =  locationManager.exposedLocation?.coordinate.latitude.description ?? ""
            savedLng =  locationManager.exposedLocation?.coordinate.longitude.description ?? ""
            
            locationManager.reverseGeocode(location: location){ placemark, error in
                if let area = placemark?.locality, let country = placemark?.country {
                    self.currentArea = "\(area), \(country)"
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    
    
}


#Preview {
    ChangeAddressView( ddViewModel: AddressSearchViewModel(apiManager: APIManager()))
}
