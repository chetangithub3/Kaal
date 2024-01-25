//
//  LocationManager.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/5/23.
//

import Foundation
import CoreLocation
import UIKit


class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {

    private let locationManager = CLLocationManager()
    
    @Published var exposedLocation: CLLocation?
    @Published var neverAsked = true
    @Published var permissionGiven = false
    @Published var permissionDenied = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
//    func locationManager(_ manager: CLLocationManager,
//                         didChangeAuthorization status:      CLAuthorizationStatus) {
//
//        switch status {
//            case .notDetermined         : neverAsked = true
//            case .authorizedWhenInUse   : 
//                exposedLocation = locationManager.location
//                permissionGiven = true
//            case .authorizedAlways      : 
//                exposedLocation = locationManager.location
//                permissionGiven = true
//            case .restricted            : self.permissionDenied = true
//            case .denied                : self.permissionDenied = true
//            default                     : openAppSettings()
//        }
//    }
    
    func askPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func handleLocation() -> CLLocation? {
        
        let authStatus = locationManager.authorizationStatus
        switch authStatus {
            case .notDetermined         : askPermission()
                
            case .authorizedWhenInUse   :
                exposedLocation = locationManager.location
                permissionGiven = true
            case .authorizedAlways      :
                exposedLocation = locationManager.location
                permissionGiven = true
            case .restricted            : openAppSettings()
            case .denied                : openAppSettings()
            default                     : openAppSettings()
        }
        return locationManager.location
    }
    
    func openAppSettings() {
          if let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/") {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
