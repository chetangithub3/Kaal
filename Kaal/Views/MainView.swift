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
    @AppStorage("currentArea") var currentArea: String = ""
    @Query var savedMuhurtas: [MuhurtaModel]
    @Environment(\.modelContext) var modelContext
    var body: some View {
        TabView(selection: $selection) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(1)
            ChoghadiyaView()
                .tabItem {
                    Image(systemName: "deskclock.fill")
                    Text("Choghadiya")
                }.tag(2)
            NotificationsTabView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notifications")
                }.tag(3)
            SettingsMenuView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }.tag(4)
            HoroscopeView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Horoscope")
                }.tag(5)
        }
        
        .onAppear(perform: {
            cleanDatabase()
        })
        .tint(getTintColor())
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChangeTab"))) { _ in
            self.selection = 4
        }
    }
    
    func cleanDatabase() {
        do {
            let predicate = #Predicate<MuhurtaModel> { object in
                object.place == currentArea
            }
            let descriptor = FetchDescriptor(predicate: predicate)
            let objectList = try modelContext.fetch(descriptor)
           
            let dateList = objectList.map({$0.dateString})
            let duplicates = getDuplicates(stringArray: dateList)
            for duplicateIndex in duplicates {
                modelContext.delete(objectList[duplicateIndex])
            }
        } catch {
           print("error fetching data from database")
        }
    }
    
    func getDuplicates(stringArray: [String]) -> [Int] {
        var seenElements: [String: [Int]] = [:]
        var duplicates: [Int] = []
        
        for (index, string) in stringArray.enumerated() {
            if var indices = seenElements[string] {
                indices.append(index)
                seenElements[string] = indices
                duplicates.append(index)
            } else {
                seenElements[string] = [index]
            }
        }
        return duplicates
    }
}



#Preview {
    MainView()
}

