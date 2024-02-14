    //
    //  ContentView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/5/23.
    //

import SwiftUI
import WeatherKit
import SwiftData

struct DashboardView: View {
    @Query var savedMuhurtas: [MuhurtaModel]
    @Environment(\.modelContext) var modelContext
    @AppStorage("currentArea") var currentArea: String = ""
    
    @EnvironmentObject var viewModel: DashboardViewModel
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State private var selectedTab: Int = 0
    @State private var date = Date()
    @State var startTime = ""
    @State var endTime = ""

    var body: some View {
        
        NavigationView {
            VStack{
                ScrollView {
                    VStack(spacing: 2){
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
                                CompactDatePickerView(date: $date)
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
                }
                BannerAdView()
            }
            .background(getBackgroundColor())
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .onAppear(perform: {
                viewModel.isLoading = true
                defer { viewModel.isLoading = false}
                let muhurt =  getObject(date: date)
           
                if let muhurta = muhurt{
                    viewModel.kaal = KaalModel(dateString: muhurta.dateString, sunriseString: muhurta.sunriseString, sunsetString: muhurta.sunsetString, utcOffset: muhurta.utcOffset, timezone: muhurta.timezone, date: muhurta.date, sunrise: muhurta.sunrise, sunset: muhurta.sunset)
                } else {
                    viewModel.daylightFromLocation(on: date)
                }

                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
            })
            .onChange(of: date, { oldValue, newValue in
                let muhurta =  getObject(date: date)
                dump(muhurta)
                if let muhurta = muhurta{
                    viewModel.kaal = KaalModel(dateString: muhurta.dateString, sunriseString: muhurta.sunriseString, sunsetString: muhurta.sunsetString, utcOffset: muhurta.utcOffset, timezone: muhurta.timezone, date: muhurta.date, sunrise: muhurta.sunrise, sunset: muhurta.sunset)
                } else {
                    viewModel.daylightFromLocation(on: date)
                }
                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
                saveKaalToLocalDatabase(kaal: viewModel.kaal)
            })
            .onChange(of: viewModel.kaal.daySpan, { oldValue, newValue in
                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
            })
            .navigationTitle(Text("Home"))
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    func getObject(date: Date) -> MuhurtaModel? {
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
               let  dateString = dateFormatter.string(from: date)
          do {
              var predicate = #Predicate<MuhurtaModel> { object in
                  object.place == currentArea && object.dateString == dateString
              }
              var descriptor = FetchDescriptor(predicate: predicate)
              descriptor.fetchLimit = 1
              var object = try modelContext.fetch(descriptor)
              dump(object.first?.date)
              return object.first
          } catch {
              
              return nil
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
    
    func saveKaalToLocalDatabase(kaal: KaalModel){
        let muhurta = MuhurtaModel(place: self.currentArea , dateString: kaal.dateString, sunriseString: kaal.sunriseString, sunsetString: kaal.sunsetString, utcOffset: kaal.utcOffset, timezone: kaal.timezone, date: kaal.date, sunrise: kaal.sunrise, sunset: kaal.sunset)
        let found =  getObject(date: date)
        if found == nil {
            modelContext.insert(muhurta)
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

