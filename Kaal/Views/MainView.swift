//
//  MainView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/12/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
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
                    Text("Notifications")
                }.tag(2)
            
            SettingsMenuView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }.tag(3)
        }
  .tint(getTintColor())
        
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChangeTab"))) { _ in
            self.selection = 3
        }
    }
}

extension View {
    func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}

#Preview {
    MainView()
}


