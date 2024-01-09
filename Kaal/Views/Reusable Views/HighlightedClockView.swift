    //
    //  HighlightedClockView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/14/23.
    //

import SwiftUI

struct Highlighted24HourClockView: View {
    
    var range: ClosedRange<Date>
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State private var percentage: CGFloat = .zero
    var startAng: Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let calendar = Calendar.current
        let startTime = range.lowerBound
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        var hour: Double = Double(calendar.component(.hour, from: startTime) + 8)
        if hour > 24 {
            hour -= 24
        }
        let minute = Double(calendar.component(.minute, from: startTime))
        let absoluteHour: Double = (hour) + (minute/60)
        let angle = (absoluteHour * 360) / 24
        return angle
    }
    
    var endAng: Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let calendar = Calendar.current
        let startTime = range.upperBound
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        var hour: Double = Double(calendar.component(.hour, from: startTime) + 8)
        if hour > 24 {
            hour -= 24
        }
        let minute = Double(calendar.component(.minute, from: startTime))
        let absoluteHour: Double = (hour) + (minute/60)
        let angle = (absoluteHour * 360) / 24
        return angle
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            ZStack {
                
                ZStack{
                    ForEach(1...24, id: \.self) { index in
                        Rectangle()
                            .fill(.primary)
                            .frame(width: 2, height: 10)
                            .cornerRadius(2)
                            .offset(y: (width - 40) / 2)
                            .rotationEffect(.init(degrees: Double((index * 15))))
                    }
                    ForEach(1...96, id: \.self) { index in
                        Rectangle()
                            .fill(.primary)
                            .frame(width: 2, height: 5)
                            .cornerRadius(2)
                            .offset(y: (width - 30) / 2)
                            .rotationEffect(.init(degrees: Double((Double(index) * 3.75))))
                    }
                    
                    ForEach(0..<12) { index in
                        Text("\(index * 2)")
                            .rotationEffect(.init(degrees: Double(index * -30)))
                            .offset(y: (width - 70)/2)
                            .rotationEffect(.init(degrees: Double(index) * 30))
                            .rotationEffect(.init(degrees: 0))
                    }
                }
                
                Circle()
                    .stroke(.primary.opacity(0.06), lineWidth: 20)
                
                Circle()
                    .trim(from: startAng/360 + 0.25 , to: percentage == 0 ? startAng/360 + 0.25 : endAng/360 + 0.25)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round), antialiased: true)
                    .animation(.linear(duration: 1), value: 1)
                    .onAppear {
                        withAnimation {
                            self.percentage = 1.0
                        }
                    }
                durationString(from: range)
                    .font(.title)
                    .bold()
                Image(systemName: "circle")
                    .font(.callout)
                    .foregroundColor(.blue)
                    .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .rotationEffect(.init(degrees: 180))
                    .rotationEffect(.init(degrees: startAng))
                    .background(.white, in: Circle())
                    .offset(x: width/2)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: startAng))
                
                
                Image(systemName: "circle")
                    .font(.callout)
                    .foregroundColor(.blue)
                    .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .rotationEffect(.init(degrees: 180))
                    .rotationEffect(.init(degrees: endAng))
                    .background(.white, in: Circle())
                    .offset(x: width/2)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: percentage == 0 ? startAng : endAng))
                    .animation(.linear(duration: 1), value: 1)
                    .onAppear {
                        withAnimation {
                            self.percentage = 1.0
                        }
                    }
            }
        }
        .frame(width: getScreenBounds().width/1.6, height: getScreenBounds().width/1.6)
        .onChange(of: range) { _, _ in
            self.percentage = 0
            withAnimation {
                self.percentage = 1.0
            }
        }
    }
    func durationString(from range: ClosedRange<Date>) -> Text {
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

struct Highlighted12HourClockView: View {
    
    var range: ClosedRange<Date>
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    
    var startAng: Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let calendar = Calendar.current
        let startTime = range.lowerBound
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        var hour: Double = Double(calendar.component(.hour, from: startTime) + 8)
        if hour > 24 {
            hour -= 24
        }
        let minute = Double(calendar.component(.minute, from: startTime))
        let absoluteHour: Double = (hour) + (minute/60)
        let angle = (absoluteHour * 360) / 12
        return angle
    }
    
    var endAng: Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let calendar = Calendar.current
        let startTime = range.upperBound
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        var hour: Double = Double(calendar.component(.hour, from: startTime) + 8)
        if hour > 24 {
            hour -= 24
        }
        let minute = Double(calendar.component(.minute, from: startTime))
        let absoluteHour: Double = (hour) + (minute/60)
        let angle = (absoluteHour * 360) / 12
        return angle
    }
    
    @State private var percentage: CGFloat = 1.0
    
    var body: some View {
        
        GeometryReader { geometry in
            let width = geometry.size.width
            
            ZStack {
                ZStack{
                    ForEach(1...60, id: \.self) { index in
                        Rectangle()
                            .fill(.primary)
                            .frame(width: 2, height: index % 5 == 0 ? 10 : 0)
                            .offset(y: (width - 35) / 2)
                            .rotationEffect(.init(degrees: Double((index * 6))))
                    }
                    ForEach(1...60, id: \.self) { index in
                        Rectangle()
                            .fill(.primary)
                            .frame(width: 2, height: index % 5 == 0 ? 0 : 5)
                            .offset(y: (width - 30) / 2)
                            .rotationEffect(.init(degrees: Double((index * 6))))
                    }
                    ForEach(1..<13) { index in
                        Text("\(index)")
                            .rotationEffect(.init(degrees: 180))
                            .rotationEffect(.init(degrees: Double(index) * -30))
                            .offset(y: (width - 70)/2)
                            .rotationEffect(.init(degrees: Double(index) * 30))
                            .rotationEffect(.init(degrees: 180))
                        
                    }
                    
                }
                Circle()
                    .stroke(.primary.opacity(0.06), lineWidth: 20)
                
                Circle()
                    .trim(from: startAng/360 - 0.25, to: percentage == 0 ? startAng/360 - 0.25 : endAng/360 - 0.25)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                
                    .animation(.linear(duration: 1), value: 1)
             
                
                durationString(from: range)
                
                Image(systemName: "circle")
                    .font(.callout)
                    .foregroundColor(.blue)
                    .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .rotationEffect(.init(degrees: 180))
                    .rotationEffect(.init(degrees: startAng))
                    .background(.white, in: Circle())
                    .offset(x: width/2)
                    .rotationEffect(.init(degrees: 180))
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: startAng))
                
                Image(systemName: "circle")
                    .font(.callout)
                    .foregroundColor(.blue)
                    .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .rotationEffect(.init(degrees: 180))
                    .rotationEffect(.init(degrees: endAng))
                    .background(.white, in: Circle())
                    .offset(x: width/2)
                    .rotationEffect(.init(degrees: 180))
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: percentage == 0 ? startAng : endAng))
                    .animation(.linear(duration: 1), value: 1)
                    
            }
        }
        .frame(width: getScreenBounds().width/1.6, height: getScreenBounds().width/1.6)
        .onAppear {
            // letting screenshot with no animation, then adding animation by changing values of percentageafter the page appears fully
            DispatchQueue.main.async {
                self.percentage = 0.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        self.percentage = 1.0
                    }
                }
            }
        }
        .onChange(of: range) { _, _ in
            self.percentage = 0
            withAnimation {
                self.percentage = 1.0
            }
        }
    }
    func durationString(from range: ClosedRange<Date>) -> Text {
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
        return  Text("Unknown duration")
        
    }
    
}

#Preview {
    Highlighted12HourClockView(range: Date()...(DateFormatter().calendar.date(byAdding: .hour, value: +8, to: Date()) ?? Date()))
}
