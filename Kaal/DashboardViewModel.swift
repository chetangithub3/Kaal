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
//https://api.sunrisesunset.io/json?lat=38.907192&lng=-77.036873&date=1990-05-22
//
//Date range request:
//https://api.sunrisesunset.io/json?lat=38.907192&lng=-77.036873&date_start=1990-05-01&date_end=1990-07-01
//{"results":{"date":"1990-05-22","sunrise":"9:52:03 AM","sunset":"12:20:21 AM","first_light":"8:01:32 AM","last_light":"2:10:52 AM","dawn":"9:21:28 AM","dusk":"12:50:56 AM","solar_noon":"5:06:12 PM","golden_hour":"11:41:50 PM","day_length":"14:28:18","timezone":"UTC","utc_offset":0},"status":"OK"}

import Foundation
import CoreLocation
import Combine
import SwiftUI

class DashboardViewModel: ObservableObject {
    
    @AppStorage("savedLat") var savedLat = ""
    @AppStorage("savedLong") var savedLng = ""
    var cancellebles = Set<AnyCancellable>()
    @Published var isLoading = false
    @Published var kaal = KaalModel(dateString: "", sunriseString: "", sunsetString: "", utcOffset: 0, timezone: "", date: Date(), sunrise: Date(), sunset: Date())
    private var apiManager: APIManagerDelegate
    
    init(apiManager: APIManagerDelegate = APIManager()) {
        self.apiManager = apiManager
    }
    
    func daylightFromLocation(on date: Date = Date()){
        let baseURL = "https://api.sunrisesunset.io/json"
        guard let lat = Double(savedLat), let lng = Double(savedLng) else {
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
        self.isLoading = true
        apiManager.publisher(for: url)
            .sink (receiveCompletion: { (completion) in
                switch completion {
                    case .finished:
                        return
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                        
                }
            }, receiveValue: { (timeData: DaylightData) in
                
                if let sunrise = timeData.results?.sunrise, let sunset = timeData.results?.sunset, let date = timeData.results?.date, let utcOffset = timeData.results?.utcOffset, let timeZone = timeData.results?.timezone {
                    
                    //formatting
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
                    dateFormatter.timeZone = TimeZone(identifier: timeZone)
                    
                    var dt = dateFormatter.date(from: "\(date) 00:00:01 AM")!
                    
                    var combinedSunrise = dateFormatter.date(from: "\(date) \(sunrise)")!
    
                    var combinedSunset = dateFormatter.date(from: "\(date) \(sunset)")!
  
                    self.kaal = KaalModel(dateString: date, sunriseString: sunrise, sunsetString: sunset, utcOffset: utcOffset, timezone: timeZone, date: dt, sunrise: combinedSunrise, sunset: combinedSunset)
                    dump(self.kaal)
                    self.isLoading = false
                }
                
            })
            .store(in: &cancellebles)
    }
}
