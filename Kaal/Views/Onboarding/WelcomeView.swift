    //
    //  WelcomeView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/23/23.
    //

import SwiftUI
import OnboardingKit

struct WelcomeView: View {
    
    @AppStorage("isFirstTime") var isFirstTime = true
    @EnvironmentObject var addressViewModel: AddressSearchViewModel
    var body: some View {
        NavigationView {
            VStack {
                Image("yantra-svg")
                    .resizable()
                    .frame(width: .infinity)
                    .padding()
                    .frame(height: getScreenBounds().width)
                    .background(Color.gray.opacity(0.2).gradient)
                
                VStack {
                    Text("Kaal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Your celestial guide to finding the right moments.")
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text("Discover the power of choosing the right moment with our app. Align your actions with the cosmic flow by tracking the most auspicious muhurtas. Increase your chances of success and reduce obstacles effortlessly.")
                           .font(.headline)
                           .lineLimit(1)
                           .minimumScaleFactor(0.5)
                }
                .padding()
                
                Spacer()
                
                NavigationLink(destination: LocationPermissionView().environmentObject(addressViewModel)) {
                    Text("Next")
                }
                
            }.frame(alignment: .top)
            
        }
        .ignoresSafeArea()
        .toolbar(.hidden)
    }
}

#Preview {
    WelcomeView()
}
