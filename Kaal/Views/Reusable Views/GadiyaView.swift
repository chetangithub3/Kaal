//
//  GadiyaView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/23/24.
//

import SwiftUI

struct GadiyaView: View {
    
    var gadiya: (String, ClosedRange<Date>)
    @State private var currentTimeWithinRange = false
    @State private var timeRemaining = TimeInterval(0)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 
    @State var remainingTime = ""
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 0){
                VStack(alignment: .leading){
                    Spacer()
                    HStack(spacing: 2){
                        Text(gadiya.0)
                            .font(.title2)
                            .bold()
                    }
                    Text(Choghadiya(rawValue: gadiya.0)?.nature.title ?? "")
                        .font(.subheadline)
                    Spacer()
                }.frame(width: getScreenBounds().width * 0.25)
                    .foregroundColor(.white)
                    .background(Choghadiya(rawValue: gadiya.0)?.nature.color)
                
                Spacer()
                VStack(alignment: .leading){
                    Text("Starts at:").font(.subheadline)
                    Text(gadiya.1.lowerBound.toStringVersion())
                        .font(.title2).bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }.foregroundColor(.black)
                    .padding()
                
                Spacer()
                VStack(alignment: .leading){
                    Text("Ends at:").font(.subheadline)
                    Text(gadiya.1.upperBound.toStringVersion())
                        .font(.title2).bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }.foregroundColor(.black)
                    .padding()
                
            }.background(Choghadiya(rawValue: gadiya.0)?.nature.color.opacity(0.1))
            if currentTimeWithinRange{
                HStack(spacing: 0){
                    Rectangle()
                        .frame(width: getScreenBounds().width * 0.25)
                            .foregroundColor(Choghadiya(rawValue: gadiya.0)?.nature.color)
                   
                    
                    
                    Group{
                        Text("Active").padding(.leading).padding(.leading)
                        Spacer()
                        Image(systemName: "stopwatch.fill")
                            .symbolEffect(.variableColor.iterative)
                            .symbolVariant(.slash)
                        
                        Text(remainingTime)
                            .font(.subheadline)
                            .padding(.trailing)
                    }.foregroundColor(.black)
                        
                    
                   
                }
                .background(Choghadiya(rawValue: gadiya.0)?.nature.color.opacity(0.1))
                
                    .foregroundColor(.white)
                   
            }
        }
        .cornerRadius(8)
      
        .padding(.bottom)
        .onReceive(timer, perform: { _ in
            currentTimeWithinRange = gadiya.1.contains(Date())
            updateTimer()
        })
    }
    
    private func updateTimer() {
        if currentTimeWithinRange {
            let currentDate = Date()
            if gadiya.1.contains(currentDate) {
                timeRemaining = gadiya.1.upperBound.timeIntervalSince(currentDate)
            } else {
                timeRemaining = 0
            }
        }
        let hours = Int(timeRemaining) / 60 / 60
        var minutes = Int(timeRemaining) / 60
        while minutes > 59 {
            minutes -= 60
        }
        let seconds = Int(timeRemaining) % 60
        self.remainingTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}

//#Preview {
//    GadiyaView(gadiya: )
//}
