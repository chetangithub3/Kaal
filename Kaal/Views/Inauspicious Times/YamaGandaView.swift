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
            DatePicker("Change Date", selection: $date, displayedComponents: .date)
            
            Text("Start time: \(startTime)")
            Text("End time: \(endTime)")
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
