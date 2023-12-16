//
//  BrahmaMuhurtaView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/11/23.
//

import SwiftUI

struct BrahmaMuhurtaView: View {
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
            HighlightedClockView(range: viewModel.kaal.brahmaMahurat)
        }.onAppear(perform: {
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
        let lowerBound = dateFormatter.string(from: viewModel.kaal.brahmaMahurat.lowerBound)
        startTime = lowerBound
        let upperbound = dateFormatter.string(from: viewModel.kaal.brahmaMahurat.upperBound)
        endTime = upperbound
    }
}

#Preview {
    BrahmaMuhurtaView()
}
