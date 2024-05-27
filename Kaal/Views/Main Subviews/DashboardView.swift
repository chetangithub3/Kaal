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
    @State var choghadiya: ChoghadiyaModel?
    @State var kaalType : Kaal?
    init() {
        UINavigationBarAppearance().backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
    }
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
                        VStack{
                            HStack(spacing: 0){
                                Text(getWeekday()).font(.subheadline).bold()
                                    .padding(.horizontal)
                                Spacer()
                            }
                            
                            Section{
                                HighlightedClockView(isDaySpanMoreThan12Hours: viewModel.kaal.isDaySpanMoreThan12Hours, timezone: viewModel.kaal.timezone, range: viewModel.kaal.daySpan).padding(.bottom)
                            }
                            
                            HStack{
                                HStack {
                                    Image(systemName: "sunrise")
                                    VStack(alignment: .leading){
                                        Text("Sunrise:").font(.subheadline)
                                        Text(startTime).font(.title2).bold()
                                        
                                    }
                                }.padding(8)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                HStack {
                                    Image(systemName: "sunset")
                                    VStack(alignment: .leading){
                                        Text("Sunset:").font(.subheadline)
                                        Text(endTime).font(.title2).bold()
                                    }
                                }.padding(8)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            Text("Note: All times are according to the local time of the saved location.")
                                .noticeStyle()
                                .padding(.horizontal)
                        }
                        
                        .padding(.vertical)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding([.top, .horizontal])
                        
                        
                        
                        HStack{
                            Text("Muhurta:")
                                .bold()
                                .font(.title2)
                            Spacer()
                        }.padding([.horizontal, .top])
                        ScrollView(.horizontal) {
                            if !viewModel.kaal.dateString.isEmpty {
                                HStack(spacing: 16) {
                                    if let x = viewModel.sortedKaal {
                                        ForEach(x, id: \.1) { item in
                                            KaalTileView(kaal: item.0, name: item.1, date: $date)
                                        }
                                    }
                                    
                                }.padding(.horizontal)
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                
            }
            .background(getBackgroundColor())
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .onAppear(perform: {
                viewModel.isLoading = true
                defer { viewModel.isLoading = false}
                let muhurt =  fetchMuhurta(date: date)
                
                if let muhurta = muhurt{
                    viewModel.kaal = KaalModel(dateString: muhurta.dateString, sunriseString: muhurta.sunriseString, sunsetString: muhurta.sunsetString, utcOffset: muhurta.utcOffset, timezone: muhurta.timezone, date: muhurta.date, sunrise: muhurta.sunrise, sunset: muhurta.sunset)
                    viewModel.sortedList()
                } else {
                    viewModel.daylightFromLocation(on: date)
                }
                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
            })
            .onChange(of: date, { oldValue, newValue in
                viewModel.isLoading = true
                defer { viewModel.isLoading = false}
                let muhurta =  fetchMuhurta(date: date)
                if let muhurta = muhurta{
                    viewModel.kaal = KaalModel(dateString: muhurta.dateString, sunriseString: muhurta.sunriseString, sunsetString: muhurta.sunsetString, utcOffset: muhurta.utcOffset, timezone: muhurta.timezone, date: muhurta.date, sunrise: muhurta.sunrise, sunset: muhurta.sunset)
                    viewModel.sortedList()
                } else {
                    viewModel.daylightFromLocation(on: date)
                    saveKaalToLocalDatabase(kaal: viewModel.kaal)
                }
                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
                
            })
            .onChange(of: viewModel.kaal.daySpan, { oldValue, newValue in
                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
            })
            .navigationTitle(Text("Home"))
            .navigationBarTitleDisplayMode(.inline)
            .overlay(content: {
                VStack{
                    Spacer()
                    BannerAd320x50View()
                }
            })
            
        }
    }
    
    func fetchMuhurta(date: Date) -> MuhurtaModel? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let  dateString = dateFormatter.string(from: date)
        do {
            let predicate = #Predicate<MuhurtaModel> { object in
                object.place == currentArea && object.dateString == dateString
            }
            var descriptor = FetchDescriptor(predicate: predicate)
            descriptor.fetchLimit = 1
            let object = try modelContext.fetch(descriptor)
            return object.first
        } catch {
            return nil
        }
    }
    func getWeekday() -> String{
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMMM d, yyyy"
            return formatter
        }()
        let formattedDate = dateFormatter.string(from: date)
        dateFormatter.timeZone = TimeZone(identifier: viewModel.kaal.timezone)
        if dateFormatter.calendar.isDateInToday(date) {
            return "Today"
        }
        let components = formattedDate.components(separatedBy: ", ")
        let weekdayName = components.first ?? ""
        return weekdayName
    }
    func saveKaalToLocalDatabase(kaal: KaalModel) {
        let muhurta = MuhurtaModel(place: self.currentArea , dateString: kaal.dateString, sunriseString: kaal.sunriseString, sunsetString: kaal.sunsetString, utcOffset: kaal.utcOffset, timezone: kaal.timezone, date: kaal.date, sunrise: kaal.sunrise, sunset: kaal.sunset)
        let found = fetchMuhurta(date: date)
        if found == nil {
            modelContext.insert(muhurta)
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

