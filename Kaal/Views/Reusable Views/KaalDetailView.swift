//
//  KaalDetailView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 1/1/24.
//

import SwiftUI

struct KaalDetailView: View {
    var kaalRange: ClosedRange<Date>
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State var date = Date()
    @EnvironmentObject var viewModel: DashboardViewModel
    @State var startTime = ""
    @State var endTime = ""
    var body: some View {
        
        VStack{
            CustomDatePickerView(date: $date)
                .padding(.vertical)
                .background(Color.secondary.opacity(0.3))
           
           
            if storedTimeFormat == "hh:mm a" {
                Highlighted12HourClockView(range: kaalRange).padding(.vertical)
            } else {
                Highlighted24HourClockView(range: kaalRange).padding(.vertical)
            }
            HStack{
                VStack(alignment: .leading) {
                    Text("Start time").font(.subheadline)
                    Text(startTime).font(.title2).bold()
                }
                
                Spacer()

                VStack(alignment: .leading) {
                    Text("End time").font(.subheadline)
                    Text(endTime).font(.title2).bold()
                }
                
            }
                .padding()
               
                
            
            
        }
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(10)
            .padding()
            
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

#Preview {
    KaalDetailView(kaalRange: Date()...(DateFormatter().calendar.date(byAdding: .hour, value: +8, to: Date()) ?? Date()))
}
