//
//  NotificationsView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/12/23.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack {
                   Spacer()
            Image(systemName: "alarm.waves.left.and.right")
                .resizable()
                .scaledToFit()
                .symbolEffect(.variableColor.iterative)
                .frame(width: 100, height: 100)
                .symbolVariant(.slash)
                
               
            HStack{
                Image(systemName: "quote.opening")
                Text("Schedule notifications to keep track of the muhurtas")
                    .font(.italic(.subheadline)())
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Image(systemName: "quote.closing")
            }
            Text("Coming Soon")
                .font(.italic(.caption)())
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            
            Spacer()
               }
               .background(Color.white) // Set background color
               .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    NotificationsView()
}
