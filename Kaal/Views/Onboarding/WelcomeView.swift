    //
    //  WelcomeView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/23/23.
    //

import SwiftUI


struct WelcomeView: View {
    
    @AppStorage("isFirstTime") var isFirstTime = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Image("yantra-svg")
                        .resizable()
                        .padding()
                        .frame(width: 300, height: 300)
                        .background(Color.gray.opacity(0.2).gradient)
                        .cornerRadius(10)
                    
                    
                    VStack(spacing: 0){
                        Text("Welcome to")
                            .font(.title2)
                        
                        Text("Kaal")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Your celestial guide to finding the right moments.")
                            .font(.title2)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    
                    Text("Discover the power of choosing the right moment for your needs, with this app. Align your actions with the cosmic flow by tracking the most auspicious/inauspicious muhurtas according to the Hindu Astrology. \n\nIncrease your chances of success and reduce obstacles effortlessly.")
                        .font(.subheadline)
                        .italic()
                    
                }
                .padding()
            }.frame(alignment: .top)
            
            Spacer()
            
            NavigationLink(destination: LocationPermissionView()) {
                
                Text("Next")
                    .frame(maxWidth: .infinity)
                    
                 
            }
        }
        .ignoresSafeArea()
        .toolbar(.hidden)
    }
}

#Preview {
    WelcomeView()
}


