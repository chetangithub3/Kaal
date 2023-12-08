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




struct DaylightModel: Identifiable, Equatable {
    
    var id = UUID()
    let sunrise: Int
    let sunset: Int
    let timezone: Int
    let cityName: String
    let date: Date
    var rahuInterval: [String:Int] = ["Sunday": 8, "Monday" : 2, "Tuesday":  7, "Wednesday": 5, "Thursday": 6, "Friday": 4, "Saturday": 3]
    //3. On Mondays, 2nd part; on Tuesdays, 7th part; on Wednesdays, 5th part; on Thursdays, 6th part; on Fridays, 4th part; on Saturdays, 3rd part; and on Sundays, 8th part is called Rahukalam.

    
    var rahuStart: Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Set the date format to retrieve the weekday name

        let weekdayName = dateFormatter.string(from: date)
        
        let ranges = divideRange(start: Double(sunrise), end: Double(sunset), into: 8)
        guard ranges.count > 0 else {return 0}
        let weekdayString = dateFormatter.string(from: date)
        return Int(ranges[(rahuInterval[weekdayString] ?? 1) - 1].lowerBound)
    }
    
    var rahuEnd: Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Set the date format to retrieve the weekday name

        let weekdayName = dateFormatter.string(from: date)
        let ranges = divideRange(start: Double(sunrise), end: Double(sunset), into: 8)
        guard ranges.count > 0 else {return 0}
        let weekdayString = dateFormatter.string(from: date)
        return Int(ranges[(rahuInterval[weekdayString] ?? 1) - 1].upperBound)
    }
    
    
    
    func divideRange(start: Double, end: Double, into divisions: Int) -> [ClosedRange<Double>] {
        guard divisions > 0 else { return [] }
        
        let rangeSize = (end - start) / Double(divisions)
        var ranges = [ClosedRange<Double>]()
        
        var currentStart = start
        for _ in 0..<divisions {
            let currentEnd = currentStart + rangeSize
            ranges.append(currentStart...currentEnd)
            currentStart = currentEnd
        }
        
        // Adjust the last range's end value to match the original end if needed
        if let lastRange = ranges.last, lastRange.upperBound != end {
            let adjustedRange = lastRange.lowerBound...end
            ranges[ranges.count - 1] = adjustedRange
        }
        
        return ranges
    }
}
