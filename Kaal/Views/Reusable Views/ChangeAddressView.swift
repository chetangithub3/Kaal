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
    @State private var isExpanded = false
    @State private var is2Expanded = false
    
    var body: some View {
        VStack {
            HStack{
                Text("Current location:").font(.subheadline)
                Text("\(currentArea)").font(.subheadline).bold()
            }.padding()
            
            VStack{
                Button {
                    withAnimation {
                        self.isExpanded.toggle()
                        self.is2Expanded = false
                    }
                } label: {
                    HStack{
                        Text("Change address from your location")
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            
                    }.padding()
                }
                
                if isExpanded {
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
                            Image(systemName: "location.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Get address from your current location")
                            Spacer()
                        }.padding(.horizontal)
                    }).buttonStyle(.bordered)
                        .padding(.horizontal)
                }
            }.padding(.vertical)
                .cornerRadius(4)
                .border(.gray)
                .padding()
            
            VStack{
                Button {
                    withAnimation {
                        self.is2Expanded.toggle()
                        self.isExpanded = false
                    }
                } label: {
                    HStack{
                        Text("Search address manually")
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: is2Expanded ? "chevron.up" : "chevron.down")
                        
                    }.padding()
                }
                
                if is2Expanded {
                    searchBar
                }
                
            }.padding(.vertical)
                .cornerRadius(4)
                .border(.gray)
                .padding()
            
            
            Spacer()
            
        }.navigationTitle(Text("Change address"))
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: locationManager.permissionGiven) { oldValue, newValue in
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
    
    var searchBar: some View {
        VStack{
            HStack {
                TextField("Search city", text: $ddViewModel.searchText, onEditingChanged: { _ in
                })
                .textFieldStyle(.plain)
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(8)
                
            }
            
            .overlay {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(.primary.opacity(0.5), lineWidth: 1)
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
        }.padding(.bottom)
    }
}


#Preview {
    ChangeAddressView( ddViewModel: AddressSearchViewModel(apiManager: APIManager()))
}
