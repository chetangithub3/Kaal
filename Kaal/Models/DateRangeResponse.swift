//
//  DateRangeResponse.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/21/24.
//

import Foundation

// MARK: - DateRangeResponse
struct DateRangeResponse: Codable {
    let results: [Results]?
    let status: String?
}

// MARK: - Result
struct DayLightData: Codable {
    let date, sunrise, sunset, firstLight: String?
    let lastLight, dawn, dusk, solarNoon: String?
    let goldenHour, dayLength: String?
    let timezone: Timezone?
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

enum Timezone: String, Codable {
    case americaNewYork = "America/New_York"
}
