//
//  DashboardViewModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/5/23.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

class DashboardViewModel: ObservableObject {
    
    @ObservedObject var locationManager: LocationManager
    var cancellebles = Set<AnyCancellable>()
  
    @Published var sunrise = 0
    @Published var sunset = 0
    init() {
        locationManager = LocationManager()
    }
    
    func daylightFromLocation(){
        let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=04720e6c5a6808a994667a251ec0199a"
        guard let lat = locationManager.exposedLocation?.coordinate.latitude.magnitude, let lon = locationManager.exposedLocation?.coordinate.longitude.magnitude else {
            locationManager.askLocation()
            return
        }
        let url = baseURL +  "&lat=\(lat)&lon=\(lon)"
        guard let url = URL(string: url) else {return}
        fetchData(from: url)
    }
   
    
    func truncateString(_ input: String, fromSubstring substring: String) -> String {
           if let range = input.range(of: substring) {
               let truncatedString = input.prefix(upTo: range.lowerBound)
               return String(truncatedString)
           }
           return input
       }
    func fetchData(from url: URL) {
        APIManager.publisher(for: url)
            .sink (receiveCompletion: { (completion) in
                switch completion {
                    case .finished:
                        return
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                        
                }
            }, receiveValue: { (timeData: TimeData) in
                
                if let name = timeData.name, let sunrise = timeData.sys?.sunrise, let sunset = timeData.sys?.sunset, let timeZone = timeData.timezone {
                    let weatherModel = DaylightModel(sunrise: sunrise, sunset: sunset, timezone: timeZone, cityName: name)
                    print("\(sunset)")
                    self.sunrise = sunrise + timeZone
                    self.sunset = sunset + timeZone
                }
                
            })
            .store(in: &cancellebles)
    }
}
