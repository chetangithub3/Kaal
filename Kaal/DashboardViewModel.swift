//
//  DashboardViewModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/8/23.
//
//Standard request:
//https://api.sunrisesunset.io/json?lat=38.907192&lng=-77.036873
//
//Specific date and setting timezone request:
//https://api.sunrisesunset.io/json?lat=38.907192&lng=-77.036873&timezone=UTC&date=1990-05-22
//
//Date range request:
//https://api.sunrisesunset.io/json?lat=38.907192&lng=-77.036873&date_start=1990-05-01&date_end=1990-07-01
//{"results":{"date":"1990-05-22","sunrise":"9:52:03 AM","sunset":"12:20:21 AM","first_light":"8:01:32 AM","last_light":"2:10:52 AM","dawn":"9:21:28 AM","dusk":"12:50:56 AM","solar_noon":"5:06:12 PM","golden_hour":"11:41:50 PM","day_length":"14:28:18","timezone":"UTC","utc_offset":0},"status":"OK"}

import Foundation
import CoreLocation
import Combine
import SwiftUI

class DashboardViewModel: ObservableObject {
    
    @ObservedObject var locationManager: LocationManager
    var cancellebles = Set<AnyCancellable>()
    
    @Published var kaal = KaalModel(dateString: "", sunriseString: "", sunsetString: "", utcOffset: 0, timezone: "")
    
    init() {
        locationManager = LocationManager()
    }
    
    
    func daylightFromLocation(on date: Date = Date()){
        let baseURL = "https://api.sunrisesunset.io/json"
        guard let lat = locationManager.exposedLocation?.coordinate.latitude.magnitude, let lng = locationManager.exposedLocation?.coordinate.longitude.magnitude else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDateString = dateFormatter.string(from: date)
        let url = baseURL + "?lat=\(lat)&lng=\(lng)&date=\(formattedDateString)"
        guard let URL = URL(string: url) else {return}
        fetchData(from: URL)
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
            }, receiveValue: { (timeData: DaylightData) in
                
                if let sunrise = timeData.results?.sunrise, let sunset = timeData.results?.sunset, let date = timeData.results?.date, let utcOffset = timeData.results?.utcOffset, let timeZone = timeData.results?.timezone {
                    self.kaal = KaalModel(dateString: date, sunriseString: sunrise, sunsetString: sunset, utcOffset: utcOffset, timezone: timeZone)
                }
                
            })
            .store(in: &cancellebles)
    }
}
