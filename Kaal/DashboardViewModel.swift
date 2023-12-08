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
    @Published var daylightModel: DaylightModel
    init() {
        locationManager = LocationManager()
        daylightModel = DaylightModel(sunrise: 0, sunset: 0, timezone: 0, cityName: "", date: Date())
    }
    
    func daylightFromLocation(){
        let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=04720e6c5a6808a994667a251ec0199a"
        guard let lat = locationManager.exposedLocation?.coordinate.latitude.magnitude, let lon = locationManager.exposedLocation?.coordinate.longitude.magnitude else {
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
                    self.daylightModel = DaylightModel(sunrise: sunrise + timeZone + 1200, sunset: sunset + timeZone + 1200, timezone: timeZone, cityName: name, date: Date())
                    
                }
                
            })
            .store(in: &cancellebles)
    }
}
