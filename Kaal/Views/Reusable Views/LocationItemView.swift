//
//  LocationItemView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 1/8/24.
//

import SwiftUI

struct LocationItemView: View {
    @AppStorage("currentArea") var currentArea: String = ""
    var body: some View {
        HStack{
            Text("Location:").font(.subheadline)
            Spacer()
            Button(action: {
                NotificationCenter.default.post(name: Notification.Name("ChangeTab"), object: nil)
            }, label: {
                HStack{
                    Image(systemName: "map")
                    Text("\(currentArea)").underline(pattern: .solid)
                }
                .padding(8)
                .frame(height: 35)
                .foregroundColor(.primary)
                .background(.background)
                .cornerRadius(10)
                
            })
            
        }.padding(.horizontal)
    }
}

#Preview {
    LocationItemView()
}
