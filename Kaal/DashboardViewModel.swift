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
import SwiftData

class DashboardViewModel: ObservableObject {
    
    @AppStorage("name") var name = ""
    @AppStorage("currentArea") var currentArea: String = ""
    @AppStorage("savedLat") var savedLat = ""
    @AppStorage("savedLong") var savedLng = ""
    var cancellebles = Set<AnyCancellable>()
    @Published var isLoading = false
    @Published var kaal = KaalModel(dateString: "2024-01-16", sunriseString: "7:54:11 AM", sunsetString: "4:42:54 PM", utcOffset: -480, timezone: "America/Los_Angeles", date: Date(), sunrise: Date(), sunset: Date())
    private var apiManager: APIManagerDelegate
    @Published var sortedKaal: [(ClosedRange<Date>, Kaal)]?

    
    init(apiManager: APIManagerDelegate = APIManager()) {
        self.apiManager = apiManager
    }
    
    func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
            case 0..<12:
                return !(getFirstName().isEmpty) ? "Good Morning, \(String(describing: getFirstName()))" : "Good Morning"
            case 12..<17:
                return  !(getFirstName().isEmpty) ? "Good Afternoon, \(String(describing: getFirstName()))" : "Good Afternoon"
            default:
                return !(getFirstName().isEmpty) ? "Good Evening, \(String(describing: getFirstName()))" : "Good Evening"
        }
        
    }
    func getFirstName() -> String{
        guard !name.isEmpty else {return ""}
        let name = self.name
        let split = name.split(separator: " ")
        guard !split.isEmpty else {return ""}
        
        if let firstName = split.first?.capitalized {
            return firstName
        } else {
            return ""
        }
        
    }
    
    func sortedList() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            var list: [(ClosedRange<Date>, Kaal)] = []
            list.append((self.kaal.brahmaMahurat, Kaal.brahma))
            list.append((self.kaal.abhijitKaal, Kaal.abhijit))
            list.append((self.kaal.yamaKaal, Kaal.yama))
            list.append((self.kaal.gulikaKaal, Kaal.gulika))
            list.append((self.kaal.rahuKaal, Kaal.rahu))
            let sorted = list.sorted { $0.0.lowerBound < $1.0.lowerBound }
            self.sortedKaal = sorted
        }
        
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
        cancellebles.removeAll()
        
        apiManager.publisher(for: url)
            .sink (receiveCompletion: { [weak self] (completion) in
                switch completion {
                    case .finished:
                        return
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                        
                }
            }, receiveValue: { [weak self] (timeData: DaylightData) in
                guard let self else {return}
                if let sunrise = timeData.results?.sunrise, let sunset = timeData.results?.sunset, let date = timeData.results?.date, let utcOffset = timeData.results?.utcOffset, let timeZone = timeData.results?.timezone {
                    
                    //formatting
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
                    dateFormatter.timeZone = TimeZone(identifier: timeZone)
                    
                    let dt = dateFormatter.date(from: "\(date) 00:00:01 AM")!
                    
                    let combinedSunrise = dateFormatter.date(from: "\(date) \(sunrise)")!
    
                    let combinedSunset = dateFormatter.date(from: "\(date) \(sunset)")!
  
                    let kaal = KaalModel(place: self.currentArea , dateString: date, sunriseString: sunrise, sunsetString: sunset, utcOffset: utcOffset, timezone: timeZone, date: dt, sunrise: combinedSunrise, sunset: combinedSunset)
                    self.kaal = kaal
                    self.isLoading = false
                    sortedList()
                }
                
            })
            .store(in: &cancellebles)
    }
    
    
}
