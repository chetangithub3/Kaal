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
        VStack{
            if !isFirstTime {
                MainView().environmentObject(DashboardViewModel())
            } else {
                WelcomeView()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onDisappear {
            apiErrorCancellable?.cancel()
        }
        .onAppear {
            apiErrorCancellable = APIManager.shared.observeErrors()
                .sink { error in
                    switch error {
                        case .notFound:
                            self.errorMessage = "Resource not found"
                               showAlert = true
                        case .unhandled(let error):
                            self.errorMessage = "Unhandled error: \(error.localizedDescription)"
                               showAlert = true
                        case .badServer:
                            self.errorMessage = "Badf server: \(error.localizedDescription)"
                            showAlert = true
                    }
                }
        }
        
    }
    
}
