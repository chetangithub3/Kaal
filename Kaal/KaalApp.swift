//
//  KaalApp.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/5/23.
//

import SwiftUI

@main
struct KaalApp: App {
    @StateObject var viewModel = DashboardViewModel()
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(viewModel)
        }
    }
}
