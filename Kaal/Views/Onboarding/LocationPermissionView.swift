//
//  LocationPermissionView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/23/23.
//

import SwiftUI
import CoreLocation

struct LocationPermissionView: View {

    @State private var locationManager = CLLocationManager()
    
    var body: some View {
        VStack {
            Text("Location Permission")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Text("Why do we need your location?")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            Text("To provide you with accurate timings based on your precise location, we need access to your location information.")
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
            Button(action: {
                locationManager.requestWhenInUseAuthorization()
            }) {
                Text("Grant Location Access")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            
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
