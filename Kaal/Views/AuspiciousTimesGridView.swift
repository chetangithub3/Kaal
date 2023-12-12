//
//  AuspiciousTimesGridView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/9/23.
//

import SwiftUI

struct AuspiciousTimesGridView: View {
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())]) {
          
                NavigationLink {
                    AbhijitKaalView()
                } label: {
                    Text("Abhijit Kaal")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                
                NavigationLink {
                    BrahmaMuhurtaView()
                } label: {
                    Text("Brahma Muhurta")
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
    AuspiciousTimesGridView()
}
