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

    var isCompleted: Bool {
        return  dateInTimeZone(timezone: viewModel.kaal.timezone, date: kaal.upperBound)  <= currentDateInTimeZone(timezone: viewModel.kaal.timezone )
    }
    
    @Binding var date: Date
    var body: some View {
        VStack {
            switch name{
                case .abhijit:
                    NavigationLink {
                        AbhijitKaalView(date: $date)
                    } label: {
                        TileView(title: "Abhijit Muhurta", range: viewModel.kaal.abhijitKaal, theme: Kaal.abhijit.nature, isCompleted: isCompleted)
                    }
                case .yama:
                    
                    NavigationLink {
                        YamaGandaView(date: $date)
                    } label: {
                        TileView(title: Kaal.yama.title, range: viewModel.kaal.yamaKaal, theme: Kaal.yama.nature, isCompleted: isCompleted)
                    }
                case .rahu:
                    NavigationLink {
                        RahuKaalView(date: $date)
                    } label: {
                        TileView(title: Kaal.rahu.title, range: viewModel.kaal.rahuKaal, theme: Kaal.rahu.nature, isCompleted: isCompleted)
                    }
                case .gulika:
                    NavigationLink {
                        GulikaKaalView(date: $date)
                    } label: {
                        TileView(title: Kaal.gulika.title, range: viewModel.kaal.gulikaKaal, theme: Kaal.gulika.nature, isCompleted: isCompleted)
                    }
                case .brahma:
                    NavigationLink {
                        BrahmaMuhurtaView(date: $date)
                    } label: {
                        TileView(title: Kaal.brahma.title, range: viewModel.kaal.brahmaMahurat, theme: Kaal.brahma.nature, isCompleted: isCompleted)
                    }
            }
            
        }
    }
    func currentDateInTimeZone(timezone: String) -> Date {
        let desiredTimeZone = TimeZone(identifier: timezone)
          let currentDate = Date()
          let localOffset = TimeZone.current.secondsFromGMT(for: currentDate)
            let desiredOffset = desiredTimeZone?.secondsFromGMT(for: currentDate) ?? 0
          let interval = TimeInterval(desiredOffset - localOffset)
          return currentDate.addingTimeInterval(interval)
      }
    
    func dateInTimeZone(timezone: String, date: Date) -> Date {
        let desiredTimeZone = TimeZone(identifier: timezone)
          let currentDate = date
          let localOffset = TimeZone.current.secondsFromGMT(for: currentDate)
            let desiredOffset = desiredTimeZone?.secondsFromGMT(for: currentDate) ?? 0
          let interval = TimeInterval(desiredOffset - localOffset)
          return currentDate.addingTimeInterval(interval)
      }
}
