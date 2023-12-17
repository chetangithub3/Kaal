//
//  TileView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/14/23.
//

import SwiftUI
  
struct TileView: View {
    
    @AppStorage("timeFormat") var storedTimeFormat: String = "hh:mm a"
    var title: String
    var range: ClosedRange<Date>
    var icon: String?
    @State var duration = ""
    var body: some View {
        VStack{
            if let icon = icon{
                Image(systemName: icon)
            }
            Text(title)
            Text("\(convertTheDateRange(range: range).0) - \(convertTheDateRange(range: range).1)")
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(8)
        .foregroundColor(.white)

       
    }
    
    func convertTheDateRange(range: ClosedRange<Date>) -> (String, String){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = storedTimeFormat
        timeFormatter.timeZone = TimeZone(identifier: "UTC")
        let start = timeFormatter.string(from: range.lowerBound)
        let end = timeFormatter.string(from: range.upperBound)
        return (start,end)
    }
}

#Preview {
    TileView(title: "Test", range: Date()...Date())
}
