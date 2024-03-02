//
//  KaalTileView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 3/2/24.
//

import SwiftUI

struct KaalTileView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    let kaal: ClosedRange<Date>
    let name: Kaal
    @Binding var date: Date
    var body: some View {
        VStack {
            switch name{
                case .abhijit:
                   
                    NavigationLink {
                        AbhijitKaalView(date: $date)
                    } label: {
                        TileView(title: "Abhijit Muhurta", range: viewModel.kaal.abhijitKaal, theme: Kaal.abhijit.nature)
                    }
                case .yama:
                    
                    NavigationLink {
                        YamaGandaView(date: $date)
                    } label: {
                        TileView(title: Kaal.yama.title, range: viewModel.kaal.yamaKaal, theme: Kaal.yama.nature)
                    }
                case .rahu:
                    NavigationLink {
                        RahuKaalView(date: $date)
                    } label: {
                        TileView(title: Kaal.rahu.title, range: viewModel.kaal.rahuKaal, theme: Kaal.rahu.nature)
                    }
                case .gulika:
                    NavigationLink {
                        GulikaKaalView(date: $date)
                    } label: {
                        TileView(title: Kaal.gulika.title, range: viewModel.kaal.gulikaKaal, theme: Kaal.gulika.nature)
                    }
                case .brahma:
                    NavigationLink {
                        BrahmaMuhurtaView(date: $date)
                    } label: {
                        TileView(title: Kaal.brahma.title, range: viewModel.kaal.brahmaMahurat, theme: Kaal.brahma.nature)
                    }
                    
                
            }
            
        }
    }
}
