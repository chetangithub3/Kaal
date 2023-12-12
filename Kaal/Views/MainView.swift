//
//  MainView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/12/23.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 1
    var body: some View {
        TabView(selection: $selection) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(1)
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notification")
                }.tag(2)
            
            SettingsMenuView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Profile")
                }.tag(3)
        }
    }
}

#Preview {
    MainView()
}
