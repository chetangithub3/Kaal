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
                Spacer()
                Image(systemName: "quote.opening")
                Text("Schedule notifications to keep track of the muhurtas")
                    .font(.italic(.subheadline)())
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Image(systemName: "quote.closing")
                Spacer()
            }
            Text("Coming Soon")
                .font(.italic(.caption)())
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            
            Spacer()
               }.edgesIgnoringSafeArea(.all)
               .background(getBackgroundColor())
               
    }
}

#Preview {
    NotificationsView()
}
