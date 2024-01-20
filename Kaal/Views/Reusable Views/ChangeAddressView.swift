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
    @ObservedObject var ddViewModel: AddressSearchViewModel
    @ObservedObject var locationManager = LocationManager()
  
    var body: some View {
        VStack {
            Button(action: {
                if let location = locationManager.handleLocation() {
                    savedLat =  locationManager.exposedLocation?.coordinate.latitude.description ?? ""
                    savedLng =  locationManager.exposedLocation?.coordinate.longitude.description ?? ""
                    
                    reverseGeocode(location: location){ placemark, error in
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
                TextField("Search area", text: $ddViewModel.searchText, onEditingChanged: { _ in
                })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.primary)
                   
                Button(action: {
                    ddViewModel.callAPI(text: ddViewModel.searchText)
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .cornerRadius(8)
                }).padding(.horizontal)
                    .buttonStyle(.bordered)
                    .disabled(ddViewModel.searchText.isEmpty)
            }
             
            if ddViewModel.showDropDown && !ddViewModel.results.isEmpty {
                List{
                    ForEach(ddViewModel.results.prefix(6), id: \.self) { result in
                        let displayName = result.displayName ?? ""
                        Button(action: {
                            self.ddViewModel.showDropDown = false
                            self.ddViewModel.searchText = ""
                            if let lat = Double(result.lat ?? ""), let lon = Double(result.lon ?? "") {
                                let location =  CLLocation(latitude: lat, longitude: lon)
                                self.savedLat = result.lat ?? ""
                                self.savedLng = result.lon ?? ""
                                self.currentArea = result.displayName ?? ""
                                reverseGeocode(location: location){ placemark, error in
                                    if let area = placemark?.locality, let country = placemark?.country {
                                        self.currentArea = "\(area), \(country)"
                                        self.presentationMode.wrappedValue.dismiss()
                                    } else {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
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
            
            reverseGeocode(location: location){ placemark, error in
                if let area = placemark?.locality, let country = placemark?.country {
                    self.currentArea = "\(area), \(country)"
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func reverseGeocode(location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error) // Pass the error to the completion handler
            } else if let placemark = placemarks?.first {
                completion(placemark, nil) // Pass the placemark to the completion handler
            } else {
                // Handle no placemarks found
                completion(nil, NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No placemark found"]))
            }
        }
    }

}


#Preview {
    ChangeAddressView(ddViewModel: AddressSearchViewModel(apiManager: APIManager()))
}
