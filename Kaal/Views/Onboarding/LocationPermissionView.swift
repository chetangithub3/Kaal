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
    @StateObject var locationManager = LocationManager()
    @ObservedObject var dashboardVM = DashboardViewModel(apiManager: APIManager())
    @ObservedObject var ddViewModel = AddressSearchViewModel(apiManager: APIManager())
    @State var showNext = false
    @AppStorage("isFirstTime") var isFirstTime = true
    var body: some View {
        VStack {
            Text("Please grant the location permission, so that we can provide you with accurate timings based on your precise location.")
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding()
            Button(action: {
                locationManager.askPermission()
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
                Text("Or").padding()
                Spacer()
            }
            
            AddressSearchBarView()
            
            Spacer()
            if showNext{
                NavigationLink(destination: MainView().environmentObject(dashboardVM)) {
                    Text("Finish")
                }
            }
          
        }
        
        .onChange(of: locationManager.permissionGiven) { oldValue, newValue in
            if newValue {
                updateLocation()
            }
        }
        .onChange(of: savedLat) { oldValue, newValue in
            showNext = true
            dashboardVM.daylightFromLocation()
            
        }
        .onChange(of: dashboardVM.kaal) { oldValue, newValue in
            isFirstTime = false
        }
        
    }
    func updateLocation(){
        if let location = locationManager.handleLocation() {
            savedLat =  locationManager.exposedLocation?.coordinate.latitude.description ?? ""
            savedLng =  locationManager.exposedLocation?.coordinate.longitude.description ?? ""
            
            reverseGeocode(location: location)
            
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
//    private func checkLocationPermission() {
//          if CLLocationManager.locationServicesEnabled() {
//              switch locationManager.authorizationStatus {
//              case .authorizedWhenInUse, .authorizedAlways:
//                  locationPermissionAllowed = true
//              case .notDetermined, .restricted, .denied:
//                  locationPermissionAllowed = false
//              @unknown default:
//                  locationPermissionAllowed = false
//              }
//          } else {
//              locationPermissionAllowed = false
//          }
//      }

}

#Preview {
    LocationPermissionView()
}
