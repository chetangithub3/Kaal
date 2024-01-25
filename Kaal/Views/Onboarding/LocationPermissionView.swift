    //
    //  LocationPermissionView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/23/23.
    //

import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    
    @AppStorage("savedLat") var savedLat = ""
    @AppStorage("savedLong") var savedLng = ""
    @AppStorage("currentArea") var currentArea: String = ""
    @AppStorage("isFirstTime") var isFirstTime = true
    
    @StateObject var locationManager = LocationManager()
    @ObservedObject var dashboardVM = DashboardViewModel(apiManager: APIManager())
    @EnvironmentObject var ddViewModel: AddressSearchViewModel
    
    @State private var isKeyboardVisible = false
    @State var showNext = false
    @State var next = false
    
    
    var body: some View {
        VStack {
            
            if !isKeyboardVisible {
                
                Text("Please grant the location permission, so that we can provide you with accurate timings based on your precise location.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button(action: {
                  let location =  locationManager.handleLocation()
                    if let location = location {
                        savedLat = location.coordinate.latitude.description
                        savedLng = location.coordinate.longitude.description
                        updateLocation()
                    }
                }) {
                    Text("Check for your location")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                HStack{
                    Spacer()
                    
                    Text("Or")
                        .padding()
                    Spacer()
                }
            }
            
            AddressSearchBarView(){
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                showNext = true
            }.environmentObject(locationManager)
            
            if showNext{
                Text("Saved location:\(currentArea)")
            }
            
            Spacer()
            
            if showNext{
                Button(action: {
                    isFirstTime = false
                }, label: {
                    Text("Finish")
                })
            }
            
            NavigationLink("", destination: MainView().environmentObject(dashboardVM), isActive: $next)
        }.navigationBarHidden(true)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                self.isKeyboardVisible = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { notification in
                self.isKeyboardVisible = false
            }
        
            .onChange(of: locationManager.permissionGiven) { oldValue, newValue in
                if newValue {
                    updateLocation()
                }
            }
            .onChange(of: savedLat) { oldValue, newValue in
                dashboardVM.daylightFromLocation()
            }
            .onChange(of: dashboardVM.kaal) { oldValue, newValue in
                showNext = true
                
            }
            .onAppear(perform: checkSavedLocation)
        
    }
    
    func checkSavedLocation() {
        if !savedLat.isEmpty && !savedLng.isEmpty {
            showNext = true
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
    LocationPermissionView()
}
