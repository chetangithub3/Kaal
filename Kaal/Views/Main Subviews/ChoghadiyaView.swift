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
                           GadiyaView(gadiya: gadiya, date: $date)
                        }
                        HStack{
                            Image(systemName: "moon.fill")
                            Text("Night Choghadiya")
                            Spacer()
                        }.foregroundColor(Color.blue)
                        .font(.title3).bold()
                        ForEach(choghadiya!.nightChoghadiya.gadiyas, id: \.1.lowerBound) { gadiya in
                            GadiyaView(gadiya: gadiya, date: $date)
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



struct Glow: ViewModifier {
    var shouldGlow: Bool
    @State var throb = false
    func body(content: Content) -> some View {
        ZStack{
            if shouldGlow{
                content
                    .blur(radius: throb ? 10 : 0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(), value: throb)
                    .onAppear {
                        throb.toggle()
                    }
            }
          
            content
        }
    }
}
extension View{
    func glow(shouldGlow: Bool) -> some View {
        modifier(Glow(shouldGlow: shouldGlow))
    }
}
