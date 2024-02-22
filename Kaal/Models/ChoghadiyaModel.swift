//
//  ChoghadiyaModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/18/24.
//

import Foundation

struct ChoghadiyaModel {
    let displayAddress: String
    let date: Date
    let sunrise: Date
    let sunset: Date
    let nextDate: Date
    let nextSunrise: Date
    
    let utcOffset: Int
    let timezone: String

    var dayChoghadiya: DayChoghadiya {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let formattedDate = dateFormatter.string(from: date)
        let components = formattedDate.components(separatedBy: ", ")
        let weekdayName = components.first ?? ""
        let weekDay = Weekday(rawValue: weekdayName) ?? .sunday
        let timeRanges = divideTimeRangeIntoNParts(start: sunrise, end: sunset, numberOfParts: 8)
        return DayChoghadiya(weekDay: weekDay, timeRanges: timeRanges)
    }
    
    var nightChoghadiya: NightChoghadiya {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let formattedDate = dateFormatter.string(from: date)
        let components = formattedDate.components(separatedBy: ", ")
        let weekdayName = components.first ?? ""
        let weekDay = Weekday(rawValue: weekdayName) ?? .sunday
        let timeRanges = divideTimeRangeIntoNParts(start: sunset, end: nextSunrise, numberOfParts: 8)
        return NightChoghadiya(weekDay: weekDay, timeRanges: timeRanges)
    }
    
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

}


enum Weekday: String {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
}


struct DayChoghadiya: Identifiable {
    var id = UUID()
    
    
    var weekDay: Weekday
    
    var timeRanges: [ClosedRange<Date>]
    
    var gadiyas: [(String, ClosedRange<Date>)] {
        return getGadiyas()
    }

    func getGadiyas() -> [(String, ClosedRange<Date>)] {
        
        var gadiyas = [(String, ClosedRange<Date>)]()
        
        let part1: [Weekday: Choghadiya] = [.sunday: .udveg, .monday: .amrit, .tuesday: .rog, .wednesday: .labh, .thursday: .shubh, .friday: .char, .saturday: .kaal]
        
        let part2: [Weekday: Choghadiya] = [.sunday: .char, .monday: .kaal, .tuesday: .udveg, .wednesday: .amrit, .thursday: .rog, .friday: .labh, .saturday: .shubh]
        
        let part3: [Weekday: Choghadiya] = [.sunday: .labh, .monday: .shubh, .tuesday: .char, .wednesday: .kaal, .thursday: .udveg, .friday: .amrit, .saturday: .rog]
        
        let part4: [Weekday: Choghadiya] = [.sunday: .amrit, .monday: .rog, .tuesday: .labh, .wednesday: .shubh, .thursday: .char, .friday: .kaal, .saturday: .udveg]
        
        let part5: [Weekday: Choghadiya] = [.sunday: .kaal, .monday: .udveg, .tuesday: .amrit, .wednesday: .rog, .thursday: .labh, .friday: .shubh, .saturday: .char]
        
        let part6: [Weekday: Choghadiya] = [.sunday: .shubh, .monday: .char, .tuesday: .kaal, .wednesday: .udveg, .thursday: .amrit, .friday: .rog, .saturday: .labh]
        
        let part7: [Weekday: Choghadiya] = [.sunday: .rog, .monday: .labh, .tuesday: .shubh, .wednesday: .char, .thursday: .kaal, .friday: .udveg, .saturday: .amrit]
        
        let part8: [Weekday: Choghadiya] = [.sunday: .udveg, .monday: .amrit, .tuesday: .rog, .wednesday: .labh, .thursday: .shubh, .friday: .char, .saturday: .kaal]
        
        let title1 = part1[weekDay]?.rawValue ?? ""
        let range1 = timeRanges[0]
        let title2 = part2[weekDay]?.rawValue ?? ""
        let range2 = timeRanges[1]
        let title3 = part3[weekDay]?.rawValue ?? ""
        let range3 = timeRanges[2]
        let title4 = part4[weekDay]?.rawValue ?? ""
        let range4 = timeRanges[3]
        let title5 = part5[weekDay]?.rawValue ?? ""
        let range5 = timeRanges[4]
        let title6 = part6[weekDay]?.rawValue ?? ""
        let range6 = timeRanges[5]
        let title7 = part7[weekDay]?.rawValue ?? ""
        let range7 = timeRanges[6]
        let title8 = part8[weekDay]?.rawValue ?? ""
        let range8 = timeRanges[7]
        let gadiya1 = (title1,range1)
        gadiyas.append(gadiya1)
        let gadiya2 = (title2,range2)
        gadiyas.append(gadiya2)
        let gadiya3 = (title3,range3)
        gadiyas.append(gadiya3)
        let gadiya4 = (title4,range4)
        gadiyas.append(gadiya4)
        let gadiya5 = (title5,range5)
        gadiyas.append(gadiya5)
        let gadiya6 = (title6,range6)
        gadiyas.append(gadiya6)
        let gadiya7 = (title7,range7)
        gadiyas.append(gadiya7)
        let gadiya8 = (title8,range8)
        gadiyas.append(gadiya8)
       
        return gadiyas
    }
    
}
struct NightChoghadiya: Identifiable {
    var id = UUID()
    var weekDay: Weekday
    
    var timeRanges: [ClosedRange<Date>]
    
    var gadiyas: [(String, ClosedRange<Date>)] {
        return getGadiyas()
    }

    func getGadiyas() -> [(String, ClosedRange<Date>)] {
        
        var gadiyas = [(String, ClosedRange<Date>)]()
        
        let part1: [Weekday: Choghadiya] = [.sunday: .shubh, .monday: .char, .tuesday: .kaal, .wednesday: .udveg, .thursday: .amrit, .friday: .rog, .saturday: .labh]
        
        let part2: [Weekday: Choghadiya] = [.sunday: .amrit, .monday: .rog, .tuesday: .labh, .wednesday: .shubh, .thursday: .char, .friday: .kaal, .saturday: .udveg]
        
        let part3: [Weekday: Choghadiya] = [.sunday: .char, .monday: .kaal, .tuesday: .udveg, .wednesday: .amrit, .thursday: .rog, .friday: .labh, .saturday: .shubh]
        
        let part4: [Weekday: Choghadiya] = [.sunday: .rog, .monday: .labh, .tuesday: .shubh, .wednesday: .char, .thursday: .kaal, .friday: .udveg, .saturday: .amrit]
        
        let part5: [Weekday: Choghadiya] = [.sunday: .kaal, .monday: .udveg, .tuesday: .amrit, .wednesday: .rog, .thursday: .labh, .friday: .shubh, .saturday: .char]
      
        let part6: [Weekday: Choghadiya] = [.sunday: .labh, .monday: .shubh, .tuesday: .char, .wednesday: .kaal, .thursday: .udveg, .friday: .amrit, .saturday: .rog]
      
        let part7: [Weekday: Choghadiya] = [.sunday: .udveg, .monday: .amrit, .tuesday: .rog, .wednesday: .labh, .thursday: .shubh, .friday: .char, .saturday: .kaal]
        
        let part8: [Weekday: Choghadiya] = [.sunday: .shubh, .monday: .char, .tuesday: .kaal, .wednesday: .udveg, .thursday: .amrit, .friday: .rog, .saturday: .labh]
        
        let title1 = part1[weekDay]?.rawValue ?? ""
        let range1 = timeRanges[0]
        let title2 = part2[weekDay]?.rawValue ?? ""
        let range2 = timeRanges[1]
        let title3 = part3[weekDay]?.rawValue ?? ""
        let range3 = timeRanges[2]
        let title4 = part4[weekDay]?.rawValue ?? ""
        let range4 = timeRanges[3]
        let title5 = part5[weekDay]?.rawValue ?? ""
        let range5 = timeRanges[4]
        let title6 = part6[weekDay]?.rawValue ?? ""
        let range6 = timeRanges[5]
        let title7 = part7[weekDay]?.rawValue ?? ""
        let range7 = timeRanges[6]
        let title8 = part8[weekDay]?.rawValue ?? ""
        let range8 = timeRanges[7]
        let gadiya1 = (title1,range1)
        gadiyas.append(gadiya1)
        let gadiya2 = (title2,range2)
        gadiyas.append(gadiya2)
        let gadiya3 = (title3,range3)
        gadiyas.append(gadiya3)
        let gadiya4 = (title4,range4)
        gadiyas.append(gadiya4)
        let gadiya5 = (title5,range5)
        gadiyas.append(gadiya5)
        let gadiya6 = (title6,range6)
        gadiyas.append(gadiya6)
        let gadiya7 = (title7,range7)
        gadiyas.append(gadiya7)
        let gadiya8 = (title8,range8)
        gadiyas.append(gadiya8)
       
        return gadiyas
    }
    
}
