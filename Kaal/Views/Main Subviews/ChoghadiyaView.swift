//
//  ChoghadiyaView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/21/24.
//

import SwiftUI
import Shimmer
struct ChoghadiyaView: View {
    @StateObject var viewModel = ChoghadiyaViewModel()
    @State var date = Date()
    
    var body: some View {
        NavigationStack {
            VStack{
                if (viewModel.choghadiya != nil) {
                    let choghadiya = viewModel.choghadiya
                    CustomDatePickerView(date: $date, timezone: viewModel.timezone)
                    ScrollView {
                        HStack{
                            Image(systemName: "sun.max.fill")
                            Text("Day Choghadiya")
                            Spacer()
                        }.foregroundColor(getTintColor())
                        .font(.title3).bold()
                        
                        ForEach(choghadiya!.dayChoghadiya.gadiyas, id: \.1.upperBound) { gadiya in
                           GadiyaView(gadiya: gadiya)
                        }
                        HStack{
                            Image(systemName: "moon.fill")
                            Text("Night Choghadiya")
                            Spacer()
                        }.foregroundColor(Color.blue)
                        .font(.title3).bold()
                        ForEach(choghadiya!.nightChoghadiya.gadiyas, id: \.1.lowerBound) { gadiya in
                            GadiyaView(gadiya: gadiya)
                        }
                    }.padding()
                    .scrollIndicators(.hidden)
                    .shimmering(
                        active: viewModel.isLoading,
                        animation: .easeIn
                    )
                } else {
                    ProgressView()
                }
                
            }.navigationTitle("Choghadiya")
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: date) { oldValue, newValue in
                    viewModel.getChoghadiyas(on: newValue)
                }
            
        }
    }
}

struct GadiyaView: View {
    
    var gadiya: (String, ClosedRange<Date>)
    @State private var currentTimeWithinRange = false
    
    var body: some View {
        
        VStack(alignment: .leading){
            HStack(spacing: 0){
                VStack(alignment: .leading){
                    Spacer()
                    HStack(spacing: 2){
                        if currentTimeWithinRange{
                            Image(systemName: "stopwatch.fill")
                                .symbolEffect(.variableColor.iterative)
                                .symbolVariant(.slash)
                        }
                        
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
                }.foregroundColor(.black)
                    .padding()
                
                Spacer()
                VStack(alignment: .leading){
                    Text("Ends at:").font(.subheadline)
                    Text(gadiya.1.upperBound.toStringVersion())
                        .font(.title2).bold()
                }.foregroundColor(.black)
                    .padding()
                
            }
        }
        .background(Choghadiya(rawValue: gadiya.0)?.nature.color.opacity(0.2))
        .cornerRadius(8)
        .padding(.bottom)
        .onAppear {
            currentTimeWithinRange = gadiya.1.contains(Date())
        }
    }
}
