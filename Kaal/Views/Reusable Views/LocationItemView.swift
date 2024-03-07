    //
    //  LocationItemView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 1/8/24.
    //

import SwiftUI

struct LocationItemView: View {
    var theme: LocationItemTheme = .button
    @AppStorage("currentArea") var currentArea: String = ""
    var body: some View {
        HStack(spacing: 2){
            if theme == .button{
                Text("Location:").font(.subheadline)
                Spacer()
            } else {
                Image(systemName: "map")
            }
            
            Button(action: {
                NotificationCenter.default.post(name: Notification.Name("ChangeTab"), object: nil)
            }, label: {
                HStack{
                    if theme == .button{
                        Image(systemName: "map")
                    }
                    Text("\(currentArea)").underline(pattern: .solid)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                }
                .padding(8)
                .frame(height: 35)
                .foregroundColor(getTintColor())
                .background(getTintColor().opacity(0.2))
                .background(Color.white)
                
                .cornerRadius(10)
            })
            
        }
    }
}

#Preview {
    LocationItemView()
}
