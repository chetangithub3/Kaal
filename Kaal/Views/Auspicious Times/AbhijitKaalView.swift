//
//  AbhijitKaalView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/10/23.
//

import SwiftUI

struct AbhijitKaalView: View {
    
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State var startTime = ""
    @State var endTime = ""
    @State var date = Date()
    @EnvironmentObject var viewModel: DashboardViewModel
    
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
    }
    
    func convertDateRangeToStrings() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = storedTimeFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let lowerBound = dateFormatter.string(from: viewModel.kaal.abhijitKaal.lowerBound)
        startTime = lowerBound
        let upperbound = dateFormatter.string(from: viewModel.kaal.abhijitKaal.upperBound)
        endTime = upperbound
    }
}

#Preview {
    AbhijitKaalView()
}