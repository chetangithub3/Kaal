//
//  ChoghadiyaViewModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/21/24.
//

//Date range request:
//https://api.sunrisesunset.io/json?lat=38.907192&lng=-77.036873&date_start=1990-05-01&date_end=1990-07-01
//{"results":{"date":"1990-05-22","sunrise":"9:52:03 AM","sunset":"12:20:21 AM","first_light":"8:01:32 AM","last_light":"2:10:52 AM","dawn":"9:21:28 AM","dusk":"12:50:56 AM","solar_noon":"5:06:12 PM","golden_hour":"11:41:50 PM","day_length":"14:28:18","timezone":"UTC","utc_offset":0},"status":"OK"}
import Foundation
import CoreLocation
import Combine
import SwiftUI
import SwiftData

class ChoghadiyaViewModel: ObservableObject {
    
    
    @AppStorage("currentArea") var currentArea: String = ""
    @AppStorage("savedLat") var savedLat = ""
    @AppStorage("savedLong") var savedLng = ""
    var cancellebles = Set<AnyCancellable>()
    @Published var isLoading = false
    @Published var choghadiya: ChoghadiyaModel?
    @Published var timezone: String = "UTC"
    private var apiManager: APIManagerDelegate
    
    init(apiManager: APIManagerDelegate = APIManager()) {
        self.apiManager = apiManager
        getChoghadiyas()
    }
    
    func getChoghadiyas(on date: Date = Date()){
        
        let baseURL = "https://api.sunrisesunset.io/json"
        guard let lat = Double(savedLat), let lng = Double(savedLng) else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let nextDate = calendar.date(byAdding: .day, value: 1, to: date)!
        let formattedDateString = dateFormatter.string(from: date)
        let nextDateString = dateFormatter.string(from: nextDate)
            //&date_start=1990-05-01&date_end=1990-07-01
        let url = baseURL + "?lat=\(lat)&lng=\(lng)&date_start=\(formattedDateString)&date_end=\(nextDateString)"
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
            }, receiveValue: { [weak self] (times: DateRangeResponse) in
                guard let self else {return}
                
                guard let firstDay = times.results?.first, let lastDay = times.results?.last else {return}
                
                if let dateString = firstDay.date, let sunriseString = firstDay.sunrise, let sunsetString = firstDay.sunset, let nextDateString = lastDay.date, let nextSunriseString = lastDay.sunrise, let nextSunsetString = lastDay.sunset, let utc = firstDay.utcOffset, let timezone = firstDay.timezone {
                    self.timezone = timezone
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.timeZone = TimeZone(identifier: timezone)
                    
                    if let date = dateFormatter.date(from: dateString), let nextDate = dateFormatter.date(from: nextDateString) {
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
                        if let sunrise = dateFormatter.date(from:   "\(dateString) \(sunriseString)"),
                           let sunset = dateFormatter.date(from:  "\(dateString) \(sunsetString)"),
                           let nextSunrise = dateFormatter.date(from: "\(nextDateString) \(sunriseString)") {
                            
                            choghadiya = ChoghadiyaModel(date: date, sunrise: sunrise, sunset: sunset, nextDate: nextDate, nextSunrise: nextSunrise,  utcOffset: utc, timezone: timezone)
                        }
                        
                    }
                }
            })
            .store(in: &cancellebles)
    }
    
    
}
