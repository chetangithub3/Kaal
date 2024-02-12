//
//  MainView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/12/23.
//

import SwiftUI
import SwiftData
struct MainView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @State private var selection = 1
    
    
    var body: some View {
        TabView(selection: $selection) {
            DashboardView()
                .onAppear(perform: {
                    viewModel.daylightFromLocation()
                })
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(1)
            NotificationsTabView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notifications")
                }.tag(2)
            
            SettingsMenuView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }.tag(3)
            DatabaseView()
                .tabItem {
                    Image(systemName: "externaldrive.fill")
                    Text("DatabaseList")
                }.tag(4)
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




struct DatabaseView: View {
    
    @Query var savedMuhurtas: [MuhurtaModel]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(savedMuhurtas) { muhurta in
                    HStack{
                        Text(muhurta.sunriseString)
                        Text(muhurta.dateString)
                        Text(muhurta.place)
                    }
                }
            }
            .navigationTitle("Data List")
        }
    }
    
    
   

}
