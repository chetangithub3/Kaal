    //
    //  HighlightedClockView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/14/23.
    //

import SwiftUI

struct Highlighted24HourClockView: View, Clock {
    
    var timezone: String
    var range: ClosedRange<Date>
    
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State private var percentage: CGFloat = .zero
    
    var startAng: Double {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        dateFormatter.dateFormat = "HH:mm"
        
        let calendar = Calendar.current
        let startTime = range.lowerBound
        
        let components = calendar.dateComponents(in: TimeZone(identifier: timezone)!, from: startTime)
        let hour = Double (components.hour!)

        let minute = Double(calendar.component(.minute, from: startTime))
        let absoluteHour: Double = (hour) + (minute/60)
  
        let angle = (absoluteHour * 360) / 24
   
        return angle
    }
    
    var endAng: Double {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        dateFormatter.dateFormat = "HH:mm"
        
        let calendar = Calendar.current
        let endTime = range.upperBound
        
        let components = calendar.dateComponents(in: TimeZone(identifier: timezone)!, from: endTime)
        let hour = Double (components.hour!)
        
        let minute = Double(calendar.component(.minute, from: endTime))
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
                durationTextFromRange(from: range)
                    .font(.title)
                    .bold()
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
  
    
}

struct Highlighted12HourClockView: View, Clock {
    var timezone: String
    var range: ClosedRange<Date>
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    
    var startAng: Double {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        dateFormatter.dateFormat = "hh:mm a"
        let calendar = Calendar.current
        let startTime = range.lowerBound
        let components = calendar.dateComponents(in: TimeZone(identifier: timezone)!, from: startTime)
        var hour = Double ((dateFormatter.calendar.dateComponents(in: TimeZone(identifier: timezone)!, from: startTime)).hour!)
        let minute = Double((dateFormatter.calendar.dateComponents(in: TimeZone(identifier: timezone)!, from: startTime)).minute!)
        let absoluteHour: Double = (hour) + (minute/60)
        var angle = (absoluteHour * 360) / 12

        return angle
    }
    
    var endAng: Double {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale.current
        let calendar = Calendar.current
        let endTime = range.upperBound
        let components = calendar.dateComponents(in: TimeZone(identifier: timezone)!, from: endTime)
        var hour = Double ((dateFormatter.calendar.dateComponents(in: TimeZone(identifier: timezone)!, from: endTime)).hour!)
        let minute = Double((dateFormatter.calendar.dateComponents(in: TimeZone(identifier: timezone)!, from: endTime)).minute!)
        let absoluteHour: Double = (hour) + (minute/60)
        var angle = (absoluteHour * 360) / 12

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
                if getTrims().0 > getTrims().1 {
                    Circle()
                        .trim(from: getTrims().0 , to: percentage == 0 ? getTrims().0   :  1 )
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: -90))
                       .animation(.linear(duration: 3).delay(0.2), value: 3)
                    Circle()
                        .trim(from: 0.0001 , to: percentage == 0 ? 0.0001  :  getTrims().1 )
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: -90))
                        .animation(.linear(duration: 0.5).delay(1.2), value: 1)
                } else {
                    Circle()
                        .trim(from: getTrims().0 , to: percentage == 0 ? getTrims().0   :  getTrims().1 )
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: -90))
                        .animation(.linear(duration: 1), value: 1)
                }
               
             
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
                    
                durationTextFromRange(from: range)
                    .font(.title)
                    .bold()
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

    func getTrims() -> (CGFloat,CGFloat) {
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
}

#Preview {
    Highlighted12HourClockView(timezone: "UTC", range: Date()...(DateFormatter().calendar.date(byAdding: .hour, value: +8, to: Date()) ?? Date()))
}
