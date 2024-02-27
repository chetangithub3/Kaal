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
                        if willShowPreviousNightList(){
                            HStack(alignment: .top){
                                Image(systemName: "moon.fill").padding(.top, 8)
                                VStack(alignment: .leading){
                                    Text("Previous Night Choghadiya")
                                        .font(.title3)
                                        .bold()
                                    Text("Falls into the next day")
                                        .font(.subheadline)
                                }
                               
                                Spacer()
                            } .foregroundColor(Color.blue)
                            
                            ForEach(choghadiya!.previousNightChoghadiya.gadiyas, id: \.1.upperBound) { gadiya in
                                let startDateOfGadiya = Calendar.current.startOfDay(for: gadiya.1.upperBound)
                              let  isSame = Calendar.current.isDate(startDateOfGadiya, equalTo: date, toGranularity: .day)
                                if isSame{
                                    GadiyaView(gadiya: gadiya, date: $date, isPreviousDay: true)
                                }
                                
                            }
                        }
                       
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
                    }.padding(.horizontal)
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
                .overlay(content: {
                    VStack{
                        Spacer()
                        BannerAd320x50View()
                    }
                })

                .onChange(of: date) { oldValue, newValue in
                    viewModel.getChoghadiyas(on: newValue)
                }
                .onForeground {
                    viewModel.getChoghadiyas(on: date)
                }
            
        }    }
    
    func willShowPreviousNightList() -> Bool{
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: viewModel.choghadiya?.timezone ?? "UTC") ?? TimeZone(identifier: "UTC")!
        let sunrise = viewModel.choghadiya?.sunrise ?? Date()
        
        let sunriseStartDate = calendar.startOfDay(for: sunrise)
        let dateStart = calendar.startOfDay(for: Date())
        
        return (sunriseStartDate == dateStart) && (Date() < sunrise)
      
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
