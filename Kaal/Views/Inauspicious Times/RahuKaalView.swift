//
//  RahuKaalView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/12/23.
//

import SwiftUI

struct RahuKaalView: View {
    
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State var date = Date()
    @EnvironmentObject var viewModel: DashboardViewModel
    @State var startTime = ""
    @State var endTime = ""
    
    var body: some View {
        VStack{
            DatePicker("Change Date", selection: $date, displayedComponents: .date)
            CustomDatePicker(date: $date)
            Text("Start time: \(startTime)")
            Text("End time: \(endTime)")
            HighlightedClockView(range: viewModel.kaal.rahuKaal)
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
        let lowerBound = dateFormatter.string(from: viewModel.kaal.rahuKaal.lowerBound)
        startTime = lowerBound
        let upperbound = dateFormatter.string(from: viewModel.kaal.rahuKaal.upperBound)
        endTime = upperbound
    }
}

struct CustomDatePicker: View {
    @Binding var date: Date
    let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "EEEE, MMMM d, yyyy"
           return formatter
       }()
    
    var body: some View {
        HStack{
            Button {
                self.date = DateFormatter().calendar.date(byAdding: .day, value: -1, to: date) ?? date
            } label: {
                Image(systemName: "minus")
            }
            Text("\(dateFormatter.string(from: date))")
            
            Button {
                self.date = DateFormatter().calendar.date(byAdding: .day, value: 1, to: date) ?? date
            } label: {
                Image(systemName: "plus")
            }

        }
    }
}
#Preview {
    RahuKaalView()
}
