//
//  AuspiciousTimesGridView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/9/23.
//

import SwiftUI

struct AuspiciousTimesGridView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())]) {
          
                NavigationLink {
                    AbhijitKaalView()
                } label: {
                    TileView(title: "Abhijit Kaal", range: viewModel.kaal.abhijitKaal)
                }
                
                NavigationLink {
                    BrahmaMuhurtaView()
                } label: {
                    TileView(title: "Brahma Muhurta", range: viewModel.kaal.brahmaMahurat)
                }
            }
            
        }.padding()
    }
}

#Preview {
    AuspiciousTimesGridView()
}
