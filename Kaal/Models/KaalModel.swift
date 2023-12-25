//
//  KaalModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/24/23.
//

import Foundation

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
        let lowerBound = dateFormatter.calendar.date(byAdding: .minute, value: -3*intervalInMins, to: sunrise) ?? sunrise
        let upperBound = dateFormatter.calendar.date(byAdding: .minute, value: -intervalInMins, to: sunrise) ?? sunrise
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
