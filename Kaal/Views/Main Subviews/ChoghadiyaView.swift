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
    @AppStorage("currentArea") var currentArea: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                if (viewModel.choghadiya != nil) {
                    let choghadiya = viewModel.choghadiya
                    VStack(spacing: 2){
                        HStack(spacing: 2){
                            
                            HStack(spacing: 2) {
                                
                                Image(systemName: "calendar")
                                CompactDatePickerView(date: $date)
                            }
                            
                            Spacer()
                            LocationItemView(theme: .underlined)
                        }
//                        Text("Note: All times are according to the local time of the saved location.")
//                            .italic()
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                            .lineLimit(1)
//                            .minimumScaleFactor(0.5)
                        
                    }.padding(.horizontal)
                        .padding(.vertical, 2)
                        .background(Color.clear)
                     //   .background(.ultraThinMaterial)
                    
               
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
                                    GadiyaView(timezone: viewModel.timezone, gadiya: gadiya, date: $date, isPreviousDay: true)
                                        .environmentObject(viewModel)
                                    
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
                            GadiyaView(timezone: viewModel.timezone, gadiya: gadiya, date: $date)
                                .environmentObject(viewModel)
                        }
                        HStack{
                            Image(systemName: "moon.fill")
                            Text("Night Choghadiya")
                            Spacer()
                        }.foregroundColor(Color.blue)
                            .font(.title3).bold()
                        ForEach(choghadiya!.nightChoghadiya.gadiyas, id: \.1.lowerBound) { gadiya in
                            GadiyaView(timezone: viewModel.timezone, gadiya: gadiya, date: $date)
                                .environmentObject(viewModel)
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
                .onChange(of: currentArea, { oldValue, newValue in
                    viewModel.getChoghadiyas(on: date)
                })
                .onForeground {
                    viewModel.getChoghadiyas(on: date)
                }
            
        }
    }
    
    func willShowPreviousNightList() -> Bool{
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: viewModel.choghadiya?.timezone ?? "UTC") ?? TimeZone(identifier: "UTC")!
        let sunrise = viewModel.choghadiya?.sunrise ?? Date()
        
        let sunriseStartDate = calendar.startOfDay(for: sunrise)
        let dateStart = calendar.startOfDay(for: Date())
        
        return (sunriseStartDate == dateStart) && (Date() < sunrise)
        
    }
}

