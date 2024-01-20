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
        HStack{
            if theme == .button{
                Text("Location:").font(.subheadline)
                Spacer()
            }
           
            Button(action: {
                NotificationCenter.default.post(name: Notification.Name("ChangeTab"), object: nil)
            }, label: {
                if theme == .button{
                    HStack{
                        Image(systemName: "map")
                        Text("\(currentArea)").underline(pattern: .solid)
                    }
                    .padding(8)
                    .frame(height: 35)
                    .foregroundColor(.primary)
                    .background(.background)
                    .cornerRadius(10)
                } else {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 2, content: {
                        Image(systemName: "map")
                        Text(currentArea)
                            .font(.subheadline)
                            .underline()
                    }).foregroundColor(.primary)
                }
               
                
            })
            
        }
    }
}

#Preview {
    LocationItemView()
}
