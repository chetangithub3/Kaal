//
//  ForLaterVersions.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 1/12/24.
//

import Foundation
import SwiftUI
import SwiftData
func getCurrentTimeComponents(for timeZone: String) -> DateComponents? {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.hour, .minute, .second], from: Date())
    components.timeZone = TimeZone(identifier: timeZone)
    return components
}

struct HourHandView: View {
let angle: Double

var body: some View {
    Rectangle()
        .fill(Color.black)
        .frame(width: 5, height: 100)
        .rotationEffect(.degrees(angle))
}
}

struct MinuteHandView: View {
let angle: Double

var body: some View {
    Rectangle()
        .fill(Color.black)
        .frame(width: 3, height: 150)
        .rotationEffect(.degrees(angle))
}
}
struct FilledSector: Shape {
var startAngle: Double
var endAngle: Double
func path(in rect: CGRect) -> Path {
    var path = Path()

    // Move to the center of the rectangle
    path.move(to: CGPoint(x: rect.width / 2, y: rect.height / 2))

    // Add the sector using an arc
    path.addArc(center: CGPoint(x: rect.width / 2, y: rect.height / 2),
                radius: getScreenBounds().width/3.2 + 10,
                startAngle: .degrees(startAngle),
                endAngle: .degrees(endAngle),
                clockwise: false)

    // Close the path to fill the sector
    path.closeSubpath()

    return path
}
}

//FilledSector(startAngle: startAng, endAngle: endAng)
//               .trim(from: 0.0, to: CGFloat(percentage))
//               .rotationEffect(.degrees(-90), anchor: .center)
//               .frame(width: 100, height: 100) // Adjust size as needed
//               .foregroundColor(.green.opacity(0.4)) // Adjust color as needed
//               .animation(.easeInOut(duration: 1), value: 1)

//Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//    let formatter = DateFormatter()
//    formatter.timeZone = TimeZone(identifier: timezone)
//    formatter.dateFormat = "HH:mm:ss"
//          let currentTime = formatter.string(from: Date())
//    self.currentTime = Date()

//Rectangle()
//    .fill(.primary)
//    .cornerRadius(2.5)
//    .offset(y: -25)
//    .frame(width: 5, height: 40)
//    .rotationEffect(Angle(degrees: calculateHourAngle(time: currentTime)))
// 
//
//Rectangle()
//    .fill(.primary)
//    .cornerRadius(1.5)
//    .offset(y: -30)
//    .frame(width: 3, height: 60)
//    .rotationEffect(Angle(degrees: calculateMinuteAngle(time: currentTime)))
//  
//
//Rectangle()
//    .fill(.primary)
//    .cornerRadius(0.5)
//    .offset(y: -40)
//    .frame(width: 2, height: 80)
//    .rotationEffect(Angle(degrees: calculateSecondAngle(time: currentTime)))
//   
//
//Image(systemName: "circle.fill")
//    .font(.callout)
//    .foregroundColor(.primary)
//    .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

struct DatabaseView: View {
    
    @Query var savedMuhurtas: [MuhurtaModel]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(savedMuhurtas) { muhurta in
                    HStack{
                        Text(muhurta.dateString)
                        Text(muhurta.place)
                    }
                }
            }
            .navigationTitle("Data List")
        }
    }
}
