//
//  Protocols.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 1/8/24.
//

import Foundation
import SwiftUI

protocol Clock {
}

extension Clock {
    
    func getTrims(startAng: Double, endAng: Double) -> (CGFloat,CGFloat) {
        var startAngle = startAng
        var endAngle = endAng
        while startAngle >= 360{
            startAngle -= 360
        }
        while endAngle >= 360{
            endAngle -= 360
        }
        return (CGFloat(startAngle/360), CGFloat(endAngle/360))
        
    }
    
    func durationTextFromRange(from range: ClosedRange<Date>) -> Text {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour], from: range.lowerBound, to: range.upperBound)
        if let hours = components.hour, let minutes = components.minute {
            
            if hours == 0 {
                return
                Text("\(minutes)")
                    .bold()
                    .font(.title)
                +
                Text(" mins")
                    .font(.caption)
            } else {
                return
                Text("\(hours)")
                    .bold()
                    .font(.title)
                +
                Text(" hrs")
                    .font(.caption)
                +
                Text(" \(minutes)")
                    .bold()
                    .font(.title)
                +
                Text(" mins")
                    .font(.caption)
                
            }
        }
        return Text("Unknown duration")
        
    }
    
    func calculateHourAndMinuteAngles() -> (Double, Double) {
        let currentDate = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)

        // Calculate angles based on your specific requirements
        let hourAngle = Double(hour % 12) / 12.0 * 360.0
        let minuteAngle = Double(minute) / 60.0 * 360.0
        
        return (hourAngle, minuteAngle)
    }
    
    func calculateHourAngle(time: Date) -> Double {
         let calendar = Calendar.current
         let hour = calendar.component(.hour, from: time) % 12
         let minute = calendar.component(.minute, from: Date())
         return Double(hour * 30 + minute / 2)
     }

     func calculateMinuteAngle(time: Date) -> Double {
         let calendar = Calendar.current
         let minute = calendar.component(.minute, from: time)
         return Double(minute * 6)
     }
    func calculateSecondAngle(time: Date) -> Double {
        let calendar = Calendar.current
        let second = calendar.component(.second, from: time)
        let adjustedSecond = second == 60 ? 0 : Double(second) // Adjust for the 60th second
        return adjustedSecond * 6
     }
}
