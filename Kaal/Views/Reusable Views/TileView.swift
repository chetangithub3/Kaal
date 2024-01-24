//
//  TileView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/14/23.
//

import SwiftUI
  
struct TileView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @AppStorage("timeFormat") var storedTimeFormat: String = "hh:mm a"
    var title: String
    var range: ClosedRange<Date>
    var theme: TimeIntervalNature = TimeIntervalNature.neutral
    var icon: String?
    @State var duration = ""
    var body: some View {
        VStack(alignment: .center){
                    if let icon = icon{
                        Image(systemName: icon)
                    }
            Text(title)
                .font(.subheadline)
                .bold()
                    Text("\(convertTheDateRange(range: range).0) - \(convertTheDateRange(range: range).1)")
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
        }
        .padding()
        .frame(width: (getScreenBounds().width - 60) / 2, height: (getScreenBounds().width - 60) / 2)
        .background(
            Image("yantra-svg")
                .resizable()
                .opacity(0.1)
                .tint(.primary)
                .background(theme.color.gradient)
        )
        .cornerRadius(10)
        .foregroundColor(.white)
        

       
    }
    
    func convertTheDateRange(range: ClosedRange<Date>) -> (String, String){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = storedTimeFormat
        timeFormatter.timeZone = TimeZone(identifier: viewModel.kaal.timezone)
        let start = timeFormatter.string(from: range.lowerBound)
        let end = timeFormatter.string(from: range.upperBound)
        return (start,end)
    }
}

#Preview {
    TileView(title: "Test", range: Date()...Date())
}
