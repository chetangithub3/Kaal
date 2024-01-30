    //
    //  ContentView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/5/23.
    //

import SwiftUI
import WeatherKit

struct DashboardView: View {
    
    @AppStorage("currentArea") var currentArea: String = ""
    
    @EnvironmentObject var viewModel: DashboardViewModel
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State private var selectedTab: Int = 0
    @State private var date = Date()
    @State var startTime = ""
    @State var endTime = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0){
                    HStack{
                        Text(greeting())
                            .bold()
                            .font(.title2)
                        Spacer()
                    }
                    HStack(spacing: 2){
                       
                        HStack(spacing: 2) {
                            // Customize the appearance of the compact date picker here
                            Image(systemName: "calendar")
                            DatePicker("", selection: $date, in: Date()..., displayedComponents: [.date])
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                        }
                       
                        Spacer()
                        LocationItemView(theme: .underlined)
                    }
                    
                }.padding(.horizontal)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                VStack {
                    Section{
                        HighlightedClockView(isDaySpanMoreThan12Hours: viewModel.kaal.isDaySpanMoreThan12Hours, timezone: viewModel.kaal.timezone, range: viewModel.kaal.daySpan).padding()
                    }
                    
                    HStack{
                        HStack {
                            Image(systemName: "sunrise")
                            VStack(alignment: .leading){
                                Text("Sunrise:").font(.subheadline)
                                Text(startTime).font(.title2).bold()
                                
                            }
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "sunset")
                            VStack(alignment: .leading){
                                Text("Sunset:").font(.subheadline)
                                Text(endTime).font(.title2).bold()
                            }
                        }
                    }
                    .padding(.horizontal)
                    Text("Note: All times are according to the local time of the saved location.")
                        .italic()
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal)
                    HStack{
                        Text("Muhurta:")
                            .bold()
                            .font(.title2)
                        Spacer()
                    }.padding([.horizontal, .top])
                    ScrollView(.horizontal) {
                        if !viewModel.kaal.dateString.isEmpty {
                            HStack(spacing: 16) {
                                NavigationLink {
                                    AbhijitKaalView(date: $date)
                                } label: {
                                    TileView(title: "Abhijit Kaal", range: viewModel.kaal.abhijitKaal, theme: Kaal.abhijit.nature)
                                }
                                
                                NavigationLink {
                                    RahuKaalView(date: $date)
                                } label: {
                                    TileView(title: "Rahu Kaal", range: viewModel.kaal.rahuKaal, theme: Kaal.rahu.nature)
                                }
                                
                                NavigationLink {
                                    BrahmaMuhurtaView(date: $date)
                                } label: {
                                    TileView(title: "Brahma Muhurta", range: viewModel.kaal.brahmaMahurat, theme: Kaal.brahma.nature)
                                }
                               
                                NavigationLink {
                                    YamaGandaView(date: $date)
                                } label: {
                                    TileView(title: "Yama Ganda", range: viewModel.kaal.yamaKaal, theme: Kaal.yama.nature)
                                }
                                
                            }.padding(.horizontal)
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                }
            }.background(getBackgroundColor())
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .onAppear(perform: {
                viewModel.daylightFromLocation(on: date)
                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
            })
            .onChange(of: date, { oldValue, newValue in
                
                viewModel.daylightFromLocation(on: date)
                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
            })
            .onChange(of: viewModel.kaal.daySpan, { oldValue, newValue in
                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
            })
            .navigationTitle(Text("Kaal"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
 
    
    private func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
            case 0..<12:
                return "Good Morning"
            case 12..<17:
                return "Good Afternoon"
            default:
                return "Good Evening"
        }
    }

    
    func convertDateRangeToStrings(range: ClosedRange<Date>) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = storedTimeFormat
        dateFormatter.timeZone = TimeZone(identifier: viewModel.kaal.timezone)
        let lowerBound = dateFormatter.string(from: range.lowerBound)
        startTime = lowerBound
        let upperbound = dateFormatter.string(from: range.upperBound)
        endTime = upperbound
    }
}

#Preview {
    DashboardView()
}

