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
            VStack{
                ScrollView {
                    VStack(spacing: 16) {
                        Image("yantra-svg")
                            .resizable()
                            .padding()
                            .frame(width: 300, height: 300)
                            .background(getTintColor().opacity(0.5))
                            .cornerRadius(10)
                        
                        
                        VStack(spacing: 0){
                            Text("Welcome to")
                                .font(.title2)
                            
                            Text("Muhurta Daily")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("Your celestial guide to finding the right moments everyday.")
                                .font(.title2)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        
                        Text("\nDiscover the power of choosing the right moment for your needs, with this app. Align your actions with the cosmic flow by tracking the most auspicious/inauspicious muhurtas according to the Hindu Astrology.")
                            .font(.subheadline)
                            .italic()
                        
                        Spacer()
                    }
                    .padding()
                }
                
                NavigationLink(destination: ProfileSetupView()) {
                    Text("Next")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(getTintColor())
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }.tint(getTintColor())
    }
}

#Preview {
    WelcomeView()
}


