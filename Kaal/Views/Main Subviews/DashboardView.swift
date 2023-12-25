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
    
    @State private var selectedTab: Int = 0
    @State var date = Date()
 
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
                    
                    if !viewModel.kaal.dateString.isEmpty {
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
                }
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
