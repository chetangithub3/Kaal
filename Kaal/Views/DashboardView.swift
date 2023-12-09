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
    @ObservedObject var viewModel = DashboardViewModel()
    var body: some View {
        VStack {
            Text("Sunrise \(sunrise)")
            Text("Sunset \(sunset)")
            
            Text("Rahu Start Time:\(rahuStartKaal)")
            Text("Rahu End Time:\(rahuEndKaal)")

            Spacer()
        }
        .background(Color.gray)
        .padding()
        .onChange(of: viewModel.kaal, { oldValue, newValue in
            self.sunrise = "\(newValue.sunrise)"
            self.sunset = "\(newValue.sunset)"
            self.rahuStartKaal = "\(newValue.rahuKaal.lowerBound)"
            self.rahuEndKaal = "\(newValue.rahuKaal.upperBound)"
        })
        .onAppear(perform: {
            viewModel.daylightFromLocation()
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
