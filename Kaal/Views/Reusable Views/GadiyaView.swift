//
//  GadiyaView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/23/24.
//

import SwiftUI

struct GadiyaView: View {
    
    var gadiya: (String, ClosedRange<Date>)
    @Binding var date: Date
    @State private var currentTimeWithinRange = false
    @State private var timeRemaining = TimeInterval(0)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var isFinished = false
    @State var remainingTime = ""
    @State var fallsInTheNextDay = false
    @State var nextDayString = ""
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 0){
                VStack(alignment: .leading){
                    Spacer()
                    Divider()
                        .opacity(0.0)
                        .frame(width: getScreenBounds().width * 0.25)
                    HStack(spacing: 2){
                        Text(gadiya.0)
                            .font(.title2)
                            .bold()
                        
                       
              
                    }.padding(.horizontal)
                    Text(Choghadiya(rawValue: gadiya.0)?.nature.title ?? "")
                        .font(.subheadline)
                        .padding(.horizontal)
                    Divider()
                        .opacity(0.0)
                        .frame(width: getScreenBounds().width * 0.25)
                    Spacer()
                }
                    .foregroundColor(.white)
                    .background(isFinished ? .gray : Choghadiya(rawValue: gadiya.0)?.nature.color)
                
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
               
            }
            .background(
                 currentTimeWithinRange ?  Image("yantra-svg")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white) as? Color :  Color.clear
                   
                
            )
            .background(isFinished ? .gray.opacity(0.1) : Choghadiya(rawValue: gadiya.0)?.nature.color.opacity(0.1))
            if fallsInTheNextDay{
           
                HStack(spacing: 0){
                   
                    Rectangle()
                        .frame(width: getScreenBounds().width * 0.25)
                            .foregroundColor(Choghadiya(rawValue: gadiya.0)?.nature.color)
                    Spacer()
                    Text(nextDayString).padding([.horizontal, .bottom], 8)
                        .foregroundColor(.black)
                }
                .background(Choghadiya(rawValue: gadiya.0)?.nature.color.opacity(0.1))
                    .foregroundColor(.white)
            }
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
        .overlay(content: {
            if isFinished{
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.5)
            }
           
        })
        .cornerRadius(8)
        .padding(.bottom)
        .onAppear(perform: {
            checkNextDayFlag(date: date)
            isFinished = gadiya.1.upperBound < Date()
            currentTimeWithinRange = gadiya.1.contains(Date())
        })
        .onReceive(timer, perform: { _ in
            isFinished = gadiya.1.upperBound < Date()
            currentTimeWithinRange = gadiya.1.contains(Date())
            updateTimer()
        })
        .onChange(of: date, { oldValue, newValue in
            checkNextDayFlag(date: date)
        })
        .onForeground {
            isFinished = gadiya.1.upperBound < Date()
            currentTimeWithinRange = gadiya.1.contains(Date())
            updateTimer()
        }
    }
    
    private func checkNextDayFlag(date: Date) {
        let calendar = Calendar.current
        if !calendar.isDate(gadiya.1.upperBound, inSameDayAs: date) {
            fallsInTheNextDay = true
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, EEEE"
            let nextDay = formatter.calendar.date(byAdding: .day, value: 1, to: date)
            nextDayString = formatter.string(from: nextDay ?? Date())
        }
        
    }
    private func isBeforeCurrentTime(time: Date) -> Bool {
      let comp =  time.compare(Date())
        return comp == .orderedAscending
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
        DispatchQueue.main.async{
            self.remainingTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
    }
    
}

//#Preview {
//    GadiyaView(gadiya: )
//}
