//
//  HoroscopeOnboardingView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/26/24.
//

import SwiftUI

struct HoroscopeOnboardingView: View {
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Image("HoroscopeIcon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .symbolEffect(.variableColor.iterative)
                    .symbolVariant(.slash)
                Text("Unveil Your Destiny Today!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(getTintColor())
                    .padding(.vertical)
                Text("Unlock insights about your future based on your birthday, the time, and place of your birth.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                Spacer()
                NavigationLink {
                    AddDetailsView()
                } label: {
                    Text("Continue")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(getTintColor())
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }.padding()
        }
    }
}

#Preview {
    HoroscopeOnboardingView()
}
