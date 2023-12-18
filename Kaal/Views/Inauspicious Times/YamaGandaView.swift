//
//  YamaGandaView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/12/23.
//

import SwiftUI

struct YamaGandaView: View {
    
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State var date = Date()
    @EnvironmentObject var viewModel: DashboardViewModel
    @State var startTime = ""
    @State var endTime = ""
    
    var body: some View {
        VStack{
            CustomDatePickerView(date: $date)
            Text("Start time: \(startTime)")
            Text("End time: \(endTime)")
            if storedTimeFormat == "hh:mm a" {
                Highlighted12HourClockView(range: viewModel.kaal.yamaKaal)
            } else {
                Highlighted24HourClockView(range: viewModel.kaal.yamaKaal)
            }
        }
        .onAppear(perform: {
            convertDateRangeToStrings()
        })
        .onChange(of: date) { oldValue, newValue in
           viewModel.daylightFromLocation(on: date)
        } 
        .onChange(of: viewModel.kaal) { oldValue, newValue in
            convertDateRangeToStrings()
        }
    }
    
    func convertDateRangeToStrings() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = storedTimeFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let lowerBound = dateFormatter.string(from: viewModel.kaal.yamaKaal.lowerBound)
        startTime = lowerBound
        let upperbound = dateFormatter.string(from: viewModel.kaal.yamaKaal.upperBound)
        endTime = upperbound
    }
}

#Preview {
    YamaGandaView()
}
