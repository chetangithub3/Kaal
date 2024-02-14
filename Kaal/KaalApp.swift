    //
    //  KaalApp.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/5/23.
    //

import SwiftUI
import Combine
import SwiftData
import GoogleMobileAds

@main
struct KaalApp: App {
    var body: some Scene {
        WindowGroup {
            IntroView()
                .environment(\.colorScheme, .light)
                .onAppear(perform: {
                    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "c2e5ee090dcdb37321e5e076d9ee9c84" ]
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                })
        }.modelContainer(for: MuhurtaModel.self)
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
    @ObservedObject var addressViewModel = AddressSearchViewModel(apiManager: APIManager())
    @StateObject var dashboardViewModel = DashboardViewModel()
    
    var body: some View {
        VStack{
            if networkStatus == .disconnected{
                NetworkErrorView()
            } else {
                
                if !isFirstTime {
                    MainView().environmentObject(dashboardViewModel).environmentObject(addressViewModel)
                } else {
                    WelcomeView().environmentObject(addressViewModel)
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
