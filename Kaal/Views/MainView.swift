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
        .onAppear(perform: {
            cleanDatabase()
        })
        .tint(getTintColor())
        
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChangeTab"))) { _ in
            self.selection = 3
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




struct DatabaseView: View {
    
    @Query var savedMuhurtas: [MuhurtaModel]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(savedMuhurtas) { muhurta in
                    HStack{
                        Text(muhurta.dateString)
                        Text(muhurta.place)
                    }
                }
            }
            .navigationTitle("Data List")
        }
    }
}
