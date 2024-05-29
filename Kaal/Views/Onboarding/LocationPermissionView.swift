    //
    //  LocationPermissionView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/23/23.
    //

import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    @AppStorage("name") var name = ""
    @AppStorage("savedLat") var savedLat = ""
    @AppStorage("savedLong") var savedLng = ""
    @AppStorage("currentArea") var currentArea: String = ""
    @AppStorage("isFirstTime") var isFirstTime = true
    
    @StateObject var locationManager = LocationManager()
    @ObservedObject var dashboardVM = DashboardViewModel(apiManager: APIManager())
    @EnvironmentObject var ddViewModel: AddressSearchViewModel
    var fullName: String
    @State private var isKeyboardVisible = false
    @State var showNext = false
    @State var next = false
    @State private var isExpanded = false
    @State private var is2Expanded = false
    
    var body: some View {
        VStack {
            Text("Please grant the location permission, so that we can provide you with accurate muhurta timings based on your precise location. You may also manually enter an approximate address.")
                .font(.subheadline)
                .multilineTextAlignment(.leading)
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
                        
                    }.padding(.horizontal)
                }
                
                if is2Expanded {
                    VStack{
                        AddressSearchBarView(){
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            showNext = true
                            isExpanded = false
                            is2Expanded = false
                        }.environmentObject(locationManager)
                    }
                    
                }
                
            }.padding(.vertical)
                .cornerRadius(4)
                .border(.gray)
                .padding()
            
            
            VStack{
                Button {
                    withAnimation {
                        self.isExpanded.toggle()
                        self.is2Expanded = false
                    }
                } label: {
                    HStack{
                        Text("Check for your location")
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        
                    }.padding()
                }
                
                if isExpanded {
                    Button(action: {
                        if let location = locationManager.exposedLocation{
                            updateLocation()
                        }
                        if let location = locationManager.handleLocation() {
                            savedLat = location.coordinate.latitude.description
                            savedLng = location.coordinate.longitude.description
                            updateLocation()
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
                        }
                    }).buttonStyle(.bordered)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
            .cornerRadius(4)
            .border(.gray)
            .padding()
            .alert(isPresented: $locationManager.showAlert) {
                Alert(
                    title: Text("Location Permission"),
                    message: Text("Please enable the location permission from the Settings app"),
                    primaryButton: .default(Text("Continue")) {
                        locationManager.showAlert = false
                        locationManager.openAppSettings()
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
            if showNext{
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                        .symbolEffect(.variableColor.iterative)
                        .symbolVariant(.slash)
                    Text("Location saved:").font(.subheadline)
                    Text("\(currentArea)").font(.subheadline).bold()
                }.padding()
            }
            
            
            NavigationLink("", destination: MainView().environmentObject(dashboardVM), isActive: $next)
            
            
            Spacer()
            
            if showNext{
                Button(action: {
                    self.name = fullName
                    isFirstTime = false
                }, label: {
                    Text("Go Home")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(getTintColor())
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                       
                    
                })
            }
            
            
        } 
        .navigationTitle("Location")
           
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                self.isKeyboardVisible = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { notification in
                self.isKeyboardVisible = false
            }
            .onChange(of: locationManager.permissionGiven) { oldValue, newValue in
                if newValue {
                    updateLocation()
                    checkSavedLocation()
                }
            }
            .onChange(of: locationManager.exposedLocation, { oldValue, newValue in
                updateLocation()
                checkSavedLocation()
            })
            .onChange(of: currentArea) { oldValue, newValue in
                dashboardVM.daylightFromLocation()
            }
            .onChange(of: dashboardVM.kaal) { oldValue, newValue in
                showNext = true
                isExpanded = false
                is2Expanded = false
            }
            .onAppear(perform: checkSavedLocation)
            .onChange(of: isExpanded) { oldValue, newValue in
                if isExpanded{
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        
    }
    
    func checkSavedLocation() {
        if !savedLat.isEmpty && !savedLng.isEmpty {
            showNext = true
            isExpanded = false
            is2Expanded = false
            dashboardVM.daylightFromLocation()
        }
    }
    func updateLocation(){
        if let location = locationManager.handleLocation() {
            savedLat =  locationManager.exposedLocation?.coordinate.latitude.description ?? ""
            savedLng =  locationManager.exposedLocation?.coordinate.longitude.description ?? ""
            locationManager.reverseGeocode(location: location){placemark, error in
                if let area = placemark?.locality, let country = placemark?.country {
                    self.currentArea = "\(area), \(country)"
                } else {
                    return
                }
            }
        }
    }
    
    
    
}

#Preview {
    LocationPermissionView(fullName: "")
}
