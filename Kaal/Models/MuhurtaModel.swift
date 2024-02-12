//
//  MuhurtaModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/11/24.
//

import Foundation
import SwiftData

@Model
class MuhurtaModel {
    
    var place: String
    var dateString: String
    var sunriseString: String
    var sunsetString: String
    let utcOffset: Int
    let timezone: String
    var date: Date
    var sunrise: Date
    var sunset: Date
    
    init(place: String = "", dateString: String = "", sunriseString: String = "", sunsetString: String = "", utcOffset: Int = 0, timezone: String = "UTC", date: Date = Date(), sunrise: Date = Date(), sunset: Date = Date()) {
        self.place = place
        self.dateString = dateString
        self.sunriseString = sunriseString
        self.sunsetString = sunsetString
        self.utcOffset = utcOffset
        self.timezone = timezone
        self.date = date
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

