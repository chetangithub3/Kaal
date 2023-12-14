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
            .onAppear(perform: {
                viewModel.daylightFromLocation(on: date)
            })
            .navigationTitle(Text("Kaal"))
            
            
        }
    }
    

}

#Preview {
    DashboardView()
}
