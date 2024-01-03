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
                    
                    reverseGeocode(location: location)
                    
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
                    .padding(.horizontal)
                
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
                                reverseGeocode(location: location)
                            } else {
                                self.currentArea = result.displayName ?? ""
                            }
                           
                            self.savedLat = result.lat ?? ""
                            self.savedLng = result.lon ?? ""
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.presentationMode.wrappedValue.dismiss()
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
            if newValue {
                updateLocation()
            }
        }
        .onAppear(perform: {
            print("on current area : \(currentArea)")
        })
    }
    
    func updateLocation(){
        if let location = locationManager.handleLocation() {
            savedLat =  locationManager.exposedLocation?.coordinate.latitude.description ?? ""
            savedLng =  locationManager.exposedLocation?.coordinate.longitude.description ?? ""
            
            reverseGeocode(location: location)
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    func reverseGeocode(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                print("Reverse geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let area = placemark.locality, let country = placemark.country {
                self.currentArea = "\(area), \(country)"
            } else {
                return
            }
        }
    }
}


#Preview {
    ChangeAddressView(ddViewModel: AddressSearchViewModel(apiManager: APIManager()))
}
