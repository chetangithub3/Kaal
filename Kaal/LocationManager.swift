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

    // - Private
    private let locationManager = CLLocationManager()

    // - API
    @Published var exposedLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status:      CLAuthorizationStatus) {

        switch status {
            case .notDetermined         : locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse   : exposedLocation = locationManager.location
            case .authorizedAlways      : exposedLocation = locationManager.location
            case .restricted            : break //
            case .denied                : break //
            default                     : openAppSettings()
        }
    }
    func askLocation(){
        locationManager.requestWhenInUseAuthorization()
    }
    func openAppSettings() {
          if let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/") {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
      }
}
