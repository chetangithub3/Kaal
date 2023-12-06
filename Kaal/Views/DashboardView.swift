//
//  ContentView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/5/23.
//

import SwiftUI

struct DashboardView: View {
    @State var sunrise = ""
    @State var sunset = ""
    @ObservedObject var vm = DashboardViewModel()
    var body: some View {
        VStack {
            Text("Hello\(sunrise)")
            Text("Hello\(sunset)")
            Button("t") {
                vm.daylightFromLocation()
                
            }
        }
        .padding()
        .onChange(of: vm.sunrise, { oldValue, newValue in
            let unixTimestamp: TimeInterval = TimeInterval(newValue) // Replace this with your Unix timestamp

            // Convert Unix timestamp to Date
            let date = Date(timeIntervalSince1970: unixTimestamp)

            // Create a DateFormatter to display hours and minutes in UTC
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")

            // Format the date to display hours and minutes
            let formattedTime = dateFormatter.string(from: date)
            print("Time in UTC: \(formattedTime)")
            self.sunrise = formattedTime
        })
        .onChange(of: vm.sunset, { oldValue, newValue in
            let unixTimestamp: TimeInterval = TimeInterval(newValue) // Replace this with your Unix timestamp

            // Convert Unix timestamp to Date
            let date = Date(timeIntervalSince1970: unixTimestamp)

            // Create a DateFormatter to display hours and minutes in UTC
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")

            // Format the date to display hours and minutes
            let formattedTime = dateFormatter.string(from: date)
            print("Time in UTC: \(formattedTime)")
            self.sunset = formattedTime
        })
        .onAppear(perform: {
            vm.daylightFromLocation()
        })
    }
}

#Preview {
    DashboardView()
}
