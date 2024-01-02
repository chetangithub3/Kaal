    //
    //  KaalApp.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/5/23.
    //

import SwiftUI
import Combine

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
    @State private var errorMessage: String = ""
    @State var apiErrorCancellable: AnyCancellable?
    @State var showAlert = false
    var body: some View {
        
    }
    
}
