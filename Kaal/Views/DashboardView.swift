//
//  ContentView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/5/23.
//

import SwiftUI
import WeatherKit

struct DashboardView: View {
    @State var sunrise = ""
    @State var sunset = ""
    @State var rahuStart = ""
    @State var rahuEnd = ""
    @ObservedObject var vm = DashboardViewModel()
    var body: some View {
        VStack {
            Text("Hello\(sunrise)")
            Text("Hello\(sunset)")
            Text("Rahu Start Time:\(rahuStart)")
            Text("Rahu End Time:\(rahuEnd)")
            
            Button("t") {
                
                vm.daylightFromLocation()
                
            }
            
            Button(action: {
                calculaterSunrise()
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/.padding()
                    .background(Color.red)
            })
        }
        .padding()
        .onChange(of: vm.daylightModel, { oldValue, newValue in
            self.sunrise = convertUTC(utc: newValue.sunrise)
            self.sunset = convertUTC(utc: newValue.sunset)
            self.rahuStart = convertUTC(utc: newValue.rahuStart)
            self.rahuEnd = convertUTC(utc: newValue.rahuEnd)
        })
        .onAppear(perform: {
            vm.daylightFromLocation()
        })
    }
    
    
    
    
    func convertUTC(utc: Int) -> String {
        let unixTimestamp: TimeInterval = TimeInterval(utc) // Replace this with your Unix timestamp

        // Convert Unix timestamp to Date
        let date = Date(timeIntervalSince1970: unixTimestamp)

        // Create a DateFormatter to display hours and minutes in UTC
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        // Format the date to display hours and minutes
        let formattedTime = dateFormatter.string(from: date)
        return formattedTime
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //
    
    func calculaterSunrise(){
        let calendar = Calendar.current
        let date = Date() // Get the current date

        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date)

        if let day = dayOfYear {
            print("Day of the year: \(day)")
        } else {
            print("Unable to calculate the day of the year.")
        }
    }
}

#Preview {
    DashboardView()
}
