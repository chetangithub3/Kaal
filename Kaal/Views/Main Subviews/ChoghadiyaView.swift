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
                        ForEach(choghadiya!.dayChoghadiya.gadiyas, id: \.1.upperBound) { gadiya in
                           GadiyaView(gadiya: gadiya)
                        }
                        
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
                .onChange(of: date) { oldValue, newValue in
                    viewModel.getChoghadiyas(on: newValue)
                }
            
        }
    }
}

struct GadiyaView: View {
    var gadiya: (String, ClosedRange<Date>)
    
    var body: some View {
        
        VStack(alignment: .leading){
            HStack(spacing: 0){
                VStack(alignment: .leading){
                    Spacer()
                    Text(gadiya.0)
                        .font(.title2)
                        .frame(width: getScreenBounds().width * 0.25)
                        .bold()
                    Text(Choghadiya(rawValue: gadiya.0)?.nature.title ?? "")
                        .font(.subheadline)
                        .frame(width: getScreenBounds().width * 0.25)
                    Spacer()
                }.foregroundColor(.white)
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
    }
}
