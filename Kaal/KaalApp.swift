//
//  KaalApp.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/5/23.
//

import SwiftUI

@main
struct KaalApp: App {
    var body: some Scene {
        WindowGroup {
            IntroView()
        }
    }
}


struct IntroView: View{
    
    @AppStorage("isFirstTime") var isFirstTime = true
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    
    var body: some View {
        
        if !isFirstTime {
            MainView().environmentObject(DashboardViewModel())
        } else {
            WelcomeView()
        }
    }
    
}
