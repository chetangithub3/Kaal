//
//  DaylightModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/5/23.
//

import  Foundation
    // MARK: - WeatherData
struct TimeData: Codable {
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
}


    // MARK: - Sys
struct Sys: Codable {
    let sunrise, sunset: Int?
}




struct DaylightModel: Identifiable {
    
    var id = UUID()
    let sunrise: Int
    let sunset: Int
    let timezone: Int
    let cityName: String
}
