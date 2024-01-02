//
//  DaylightModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/5/23.
//

import  Foundation

// MARK: - DaylightData
    //Standard request:
    //https://api.sunrisesunset.io/json?lat=38.907192&lng=-77.036873
    //
    //Specific date and setting timezone request:
    //https://api.sunrisesunset.io/json?lat=38.907192&lng=-77.036873&timezone=UTC&date=1990-05-22
    //
    //Date range request:
    //https://api.sunrisesunset.io/json?lat=38.907192&lng=-77.036873&date_start=1990-05-01&date_end=1990-07-01
    //{"results":{"date":"1990-05-22","sunrise":"9:52:03 AM","sunset":"12:20:21 AM","first_light":"8:01:32 AM","last_light":"2:10:52 AM","dawn":"9:21:28 AM","dusk":"12:50:56 AM","solar_noon":"5:06:12 PM","golden_hour":"11:41:50 PM","day_length":"14:28:18","timezone":"UTC","utc_offset":0},"status":"OK"}

struct DaylightData: Codable {
    let results: Results?
    let status: String?
}

// MARK: - Results
struct Results: Codable {
    let date, sunrise, sunset, firstLight: String?
    let lastLight, dawn, dusk, solarNoon: String?
    let goldenHour, dayLength, timezone: String?
    let utcOffset: Int?

    enum CodingKeys: String, CodingKey {
        case date, sunrise, sunset
        case firstLight = "first_light"
        case lastLight = "last_light"
        case dawn, dusk
        case solarNoon = "solar_noon"
        case goldenHour = "golden_hour"
        case dayLength = "day_length"
        case timezone
        case utcOffset = "utc_offset"
    }
}

