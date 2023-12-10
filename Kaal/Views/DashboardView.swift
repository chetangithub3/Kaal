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
    @State var rahuStartKaal = ""
    @State var rahuEndKaal = ""
    @State var yamaStartKaal = ""
    @State var yamaEndKaal = ""
    @State var abhiStart = ""
    @State var abhiEnd = ""
    @State var date = Date()
    @ObservedObject var viewModel = DashboardViewModel()
    var body: some View {
        VStack {
            
            DatePicker("select date", selection: $date, displayedComponents: .date)
            
            Text("Sunrise \(sunrise)")
            Text("Sunset \(sunset)")
            
            Text("Rahu Start Time:\(rahuStartKaal)")
            Text("Rahu End Time:\(rahuEndKaal)")
            Text("Yama Start Time:\(yamaStartKaal)")
            Text("Yama End Time:\(yamaEndKaal)")
            Text("Abhijit Start Time:\(abhiStart)")
            Text("Abhijit End Time:\(abhiEnd)")
            Spacer()
        }
        .background(Color.gray)
        .padding()
        .onChange(of: viewModel.kaal, { oldValue, newValue in
            self.sunrise = "\(newValue.sunrise)"
            self.sunset = "\(newValue.sunset)"
            self.rahuStartKaal = "\(newValue.rahuKaal.lowerBound)"
            self.rahuEndKaal = "\(newValue.rahuKaal.upperBound)"
            self.yamaStartKaal = "\(newValue.yamaKaal.lowerBound)"
            self.yamaEndKaal = "\(newValue.yamaKaal.upperBound)"
            self.abhiStart = "\(newValue.abhijitKaal.lowerBound)"
            self.abhiEnd = "\(newValue.abhijitKaal.upperBound)"
        })
        .onAppear(perform: {
            viewModel.daylightFromLocation(on: date)
        })
        .onChange(of: date) { oldValue, newValue in
            viewModel.daylightFromLocation(on: date)
        }
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
    

}

#Preview {
    DashboardView()
}
