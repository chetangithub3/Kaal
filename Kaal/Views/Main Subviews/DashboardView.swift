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
    @State var date = Date()
    @State var progress = 0.7
    @State var startTime = ""
    @State var endTime = ""
    @State var currentDate = ""
    var body: some View {
        NavigationView {
            ScrollView {
                VStack{
                    HStack{
                        Text(greeting())
                            .bold()
                            .font(.title2)
                        Spacer()
                    }
                    HStack(spacing: 2){
                        Image(systemName: "calendar")
                        Text(currentDate).font(.subheadline)
                        Spacer()
                        LocationItemView(theme: .underlined)
                    }
                    
                }.padding(.horizontal)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                VStack {
                    if storedTimeFormat == "hh:mm a" {
                        Highlighted12HourClockView(timezone: viewModel.kaal.timezone, range: viewModel.kaal.daySpan).padding(.vertical)
                    } else {
                        Highlighted24HourClockView(timezone: viewModel.kaal.timezone, range: viewModel.kaal.daySpan).padding(.vertical)
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
                        Text("Mahurat:")
                            .bold()
                            .font(.title2)
                        Spacer()
                    }.padding([.horizontal, .top])
                    ScrollView(.horizontal) {
                        if !viewModel.kaal.dateString.isEmpty {
                            HStack(spacing: 16) {
                                NavigationLink {
                                    AbhijitKaalView()
                                } label: {
                                    TileView(title: "Abhijit Kaal", range: viewModel.kaal.abhijitKaal, theme: Kaal.abhijit.nature)
                                }
                                
                                NavigationLink {
                                    RahuKaalView()
                                } label: {
                                    TileView(title: "Rahu Kaal", range: viewModel.kaal.rahuKaal, theme: Kaal.rahu.nature)
                                }
                                
                                NavigationLink {
                                    BrahmaMuhurtaView()
                                } label: {
                                    TileView(title: "Brahma Muhurta", range: viewModel.kaal.brahmaMahurat, theme: Kaal.brahma.nature)
                                }
                               
                                NavigationLink {
                                    YamaGandaView()
                                } label: {
                                    TileView(title: "Yama Ganda", range: viewModel.kaal.yamaKaal, theme: Kaal.yama.nature)
                                }
                                
                            }.padding(.horizontal, 16)
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                }
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .onAppear(perform: {
                viewModel.daylightFromLocation(on: date)
                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
            })
            .onChange(of: viewModel.kaal.daySpan, { oldValue, newValue in
                convertDateRangeToStrings(range: viewModel.kaal.daySpan)
                formattedDate()
            })
            .navigationTitle(Text("Kaal"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func formattedDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        formatter.timeZone = TimeZone(identifier: viewModel.kaal.timezone) 
        currentDate = formatter.string(from: viewModel.kaal.date)
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

struct StickyLayoutGrid: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
        NavigationView {
            ScrollView(.vertical) { //set .horizontal to scroll horizontally
                                    ///pinnedViews: [.sectionHeaders] => set header or footer you want to pin. if do not want to pin leave empty, sectionFooters => for sticky footer
                LazyVGrid(columns: columns, spacing: 10, pinnedViews: [.sectionHeaders]) {
                    Section(header: headerView(type: "Grid")) {
                        ForEach(0..<10) { i in
                            Text("Grid: \(i)").frame(width: 100, height: 100, alignment: .center).background(Color.gray).cornerRadius(10.0)
                        }
                    }
                }
                LazyVStack(spacing: 3, pinnedViews: [.sectionHeaders]) {
                    Section(header: headerView(type: "List")) {
                        ForEach(0..<15) { i in
                            HStack {
                                Spacer()
                                Text("List: \(i)")
                                Spacer()
                            }.padding(.all, 30).background(Color.gray)
                        }
                    }
                }
            }
            .navigationTitle("Sticky Header")
        }
    }
    func headerView(type: String) -> some View{
        return HStack {
            Spacer()
            Text("Section header \(type)")
            Spacer()
        }.padding(.all, 10).background(Color.blue)
    }
}
