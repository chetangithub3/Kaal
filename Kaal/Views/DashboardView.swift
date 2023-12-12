    //
    //  ContentView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/5/23.
    //

import SwiftUI
import WeatherKit

struct DashboardView: View {
    
    @State private var selectedTab: Int = 0
    @State var sunrise = ""
    @State var sunset = ""
    @State var rahuStartKaal = ""
    @State var rahuEndKaal = ""
    @State var yamaStartKaal = ""
    @State var yamaEndKaal = ""
    @State var abhiStart = ""
    @State var abhiEnd = ""
    @State var brahmaStart = ""
    @State var brahmaEnd = ""
    @State var date = Date()
    @EnvironmentObject var viewModel: DashboardViewModel
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Picker("", selection: $selectedTab) {
                        Text("Auspicious").tag(0)
                        Text("Inauspicious").tag(1)
                        Text("More").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                   
                    TabView(selection: $selectedTab) {
                        AuspiciousTimesGridView().tag(0)
                        InauspiciousTimesGridView().tag(1)
                        OthersGridView().tag(2)
                    }
                    .animation(.easeInOut)
                    .transition(.slide)
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .never))
                    
                    

                }

                Spacer()
            }
            .foregroundColor(Color(red: 9/255, green: 38/255, blue: 53/255))
            
            .onAppear(perform: {
                viewModel.daylightFromLocation(on: date)
            })
            .navigationTitle(Text("Kaal"))
            .background(Color(red: 246/255, green: 244/255, blue: 235/255))
            .background(ignoresSafeAreaEdges: .all)
            
            
        }
    }
    

}

#Preview {
    DashboardView()
}
