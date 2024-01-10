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
//            NotificationsView()
//                .tabItem {
//                    Image(systemName: "bell.fill")
//                    Text("Notification")
//                }.tag(2)
            
            SettingsMenuView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }.tag(3)
        } .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChangeTab"))) { _ in
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



import SwiftUI
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
struct StickyLayoutGrid_Previews: PreviewProvider {
    static var previews: some View {
        StickyLayoutGrid()
    }
}
