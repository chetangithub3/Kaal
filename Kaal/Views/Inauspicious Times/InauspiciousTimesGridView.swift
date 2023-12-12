//
//  InauspiciousTimesGridView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/9/23.
//

import SwiftUI

struct InauspiciousTimesGridView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())]) {
          
                NavigationLink {
                    RahuKaalView()
                } label: {
                    Text("Rahu Kaal")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                
                NavigationLink {
                    YamaGandaView()
                } label: {
                    Text("Yama Ganda")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
            }
            
        }.padding()
    }
}

#Preview {
    InauspiciousTimesGridView()
}
