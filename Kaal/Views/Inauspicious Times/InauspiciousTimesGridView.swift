//
//  InauspiciousTimesGridView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/9/23.
//

import SwiftUI

struct InauspiciousTimesGridView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())]) {
          
                NavigationLink {
                    RahuKaalView()
                } label: {
                    TileView(title: "Rahu Kaal", range: viewModel.kaal.rahuKaal)
                }
                
                NavigationLink {
                    YamaGandaView()
                } label: {
                    TileView(title: "Yama Ganda", range: viewModel.kaal.yamaKaal)
                }
            }
            
        }.padding()
    }
}

#Preview {
    InauspiciousTimesGridView()
}
