//
//  DaylightModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/5/23.
//

import  Foundation
    // MARK: - TimeData
struct TimeData: Codable {
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
}


    // MARK: - Sys
struct Sys: Codable {
    let sunrise, sunset: Int?
}


// MARK: - DaylightData API 2


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

struct KaalModel: Identifiable, Equatable {
    static func == (lhs: KaalModel, rhs: KaalModel) -> Bool {
        return (lhs.place == rhs.place) && (lhs.dateString == rhs.dateString)
    }
    
    
    var id = UUID()
    var place: String = ""
    var dateString: String
    var sunriseString: String
    var sunsetString: String
    let utcOffset: Int?
    let timezone: String?
    
    var date: Date {
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        var dt = dateFormatter.date(from: "\(dateString) 00:00:00 AM")!
        dt = dateFormatter.calendar.date(byAdding: .hour, value: -8, to: dt) ?? dt
        dt = dateFormatter.calendar.date(byAdding: .second, value: 1, to: dt) ?? dt
        return dt
    }
    var sunrise: Date {
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        var combined = dateFormatter.date(from: "\(dateString) \(sunriseString)")!
        combined = dateFormatter.calendar.date(byAdding: .hour, value: -8, to: combined) ?? combined
        combined = dateFormatter.calendar.date(byAdding: .minute, value: 20, to: combined) ?? combined
        return combined
    }
    var sunset: Date {
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        var combined = dateFormatter.date(from: "\(dateString) \(sunsetString)")!
        combined = dateFormatter.calendar.date(byAdding: .hour, value: -8, to: combined) ?? combined
        combined = dateFormatter.calendar.date(byAdding: .minute, value: 20, to: combined) ?? combined
        return combined
    }

    // logic
    var rahuInterval: [String:Int] = ["Sunday": 8, "Monday" : 2, "Tuesday":  7, "Wednesday": 5, "Thursday": 6, "Friday": 4, "Saturday": 3]
    
    var yamaInterval: [String:Int] = ["Sunday": 5, "Monday" : 4, "Tuesday":  3, "Wednesday": 2, "Thursday": 1, "Friday": 7, "Saturday": 6]
    
    
    var rahuKaal: ClosedRange<Date> {
        let ranges = divideTimeRangeIntoNParts(start: sunrise, end: sunset, numberOfParts: 8)

        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dt = dateFormatter.date(from: "\(dateString)")!
        dateFormatter.dateFormat = "EEEE"
        return ranges[(rahuInterval[dateFormatter.string(from: dt)] ?? 1) - 1]
    }
    
    var yamaKaal: ClosedRange<Date> {
        let ranges = divideTimeRangeIntoNParts(start: sunrise, end: sunset, numberOfParts: 8)
  
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dt = dateFormatter.date(from: "\(dateString)")!
        dateFormatter.dateFormat = "EEEE"
        return ranges[(yamaInterval[dateFormatter.string(from: dt)] ?? 1) - 1]
    }
    
    var abhijitKaal: ClosedRange<Date> {
        let ranges = divideTimeRangeIntoNParts(start: sunrise, end: sunset, numberOfParts: 15)
        var myDate = date
        myDate = dateFormatter.calendar.date(byAdding: .hour, value: 12, to: myDate) ?? myDate
        let myRange = rangeContainingTime(ranges: ranges, timeToCheck: myDate)
        return myRange ?? ranges[7]
    }
    
    var brahmaMahurat: ClosedRange<Date> {
        let ranges = divideTimeRangeIntoNParts(start: sunrise, end: sunset, numberOfParts: 8)
        guard let intervalInMins = Calendar.current.dateComponents([.minute], from: ranges[0].lowerBound, to: ranges[0].upperBound).minute else {
            return ranges[0]
        }
        print("%%%")
        print(intervalInMins)
        
        let lowerBound = dateFormatter.calendar.date(byAdding: .minute, value: -3*intervalInMins, to: sunrise) ?? sunrise
        print("%%% - \(lowerBound)")
        let upperBound = dateFormatter.calendar.date(byAdding: .minute, value: -intervalInMins, to: sunrise) ?? sunrise
        print("%%% - \(upperBound)")
        return lowerBound...upperBound
    }
    
    // helper
    let dateFormatter = DateFormatter()
    
    func divideTimeRangeIntoNParts(start: Date, end: Date, numberOfParts: Int) -> [ClosedRange<Date>] {
        guard numberOfParts > 0 else {
            fatalError("Number of parts should be greater than zero.")
        }
        
        let timeDifference = end.timeIntervalSince(start)
        let interval = timeDifference / Double(numberOfParts)
        
        var ranges: [ClosedRange<Date>] = []
        var currentDate = start
        
        for _ in 0..<numberOfParts {
            let nextDate = currentDate + interval
            ranges.append(currentDate...nextDate)
            currentDate = nextDate
        }
        return ranges
    }
    
    func rangeContainingTime(ranges: [ClosedRange<Date>], timeToCheck: Date) -> ClosedRange<Date>? {
        for range in ranges {
            if range.contains(timeToCheck) {
                return range
            }
        }
        return nil
    }
}
