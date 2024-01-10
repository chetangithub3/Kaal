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
    @State var networkStatus: NetworkStatus = .connected
    @State private var timer: Timer? = nil
    @AppStorage("isFirstTime") var isFirstTime = true
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State private var errorMessage: String = ""
    @State var apiErrorCancellable: AnyCancellable?
    @State var showAlert = false
    var body: some View {
        VStack{
            if networkStatus == .disconnected{
                NetworkErrorView()
            } else {
                
                if !isFirstTime {
                    MainView().environmentObject(DashboardViewModel())
                } else {
                    WelcomeView()
                }
            }
            
        }
        .onAppear {
            NetworkManager.shared.startMonitoring()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.networkStatus = NetworkManager.shared.isNetworkAvailable ? .connected : .disconnected
            }
        }
        .onDisappear {
            NetworkManager.shared.stopMonitoring()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onDisappear {
            apiErrorCancellable?.cancel()
        }
    }
    
}
