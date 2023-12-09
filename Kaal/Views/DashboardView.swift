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
    @State var sunriseKaal = ""
    @State var sunsetKaal = ""
    @State var rahuStartKaal = ""
    @State var rahuEndKaal = ""
    @ObservedObject var vm = DashboardViewModelTest()
    @ObservedObject var vm2 = DashboardViewModel()
    var body: some View {
        VStack {
            Text("Hello\(sunrise)")
            Text("Hello\(sunset)")
            Text("Rahu Start Time:\(rahuStart)")
            Text("Rahu End Time:\(rahuEnd)")
            
            Button("t") {
                
                vm.daylightFromLocation()
                
            }
            
            Text("Kaal\(sunriseKaal)")
            Text("Kaal\(sunsetKaal)")
            Text("Rahu Start Time:\(rahuStartKaal)")
            Text("Rahu End Time:\(rahuEndKaal)")
            
            Button(action: {
                calculaterSunrise()
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/.padding()
                    .background(Color.red)
            })
            Spacer()
        }
        .background(Color.gray)
        .padding()
        .onChange(of: vm.daylightModel, { oldValue, newValue in
            self.sunrise = convertUTC(utc: newValue.sunrise)
            self.sunset = convertUTC(utc: newValue.sunset)
            self.rahuStart = convertUTC(utc: newValue.rahuStart)
            self.rahuEnd = convertUTC(utc: newValue.rahuEnd)
        })
        .onChange(of: vm2.kaal, { oldValue, newValue in
            self.sunrise = newValue.sunriseString
            self.sunset = newValue.sunsetString
            self.rahuStartKaal = "\(newValue.rahuKaal.lowerBound)"
            self.rahuEndKaal = "\(newValue.rahuKaal.upperBound)"
        })
        .onAppear(perform: {
            vm.daylightFromLocation()
        })
        .onAppear(perform: {
            vm2.daylightFromLocation()
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

     
    }
}

#Preview {
    DashboardView()
}
