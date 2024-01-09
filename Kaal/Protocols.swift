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
}
