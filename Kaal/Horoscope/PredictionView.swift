//
//  PredictionView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 6/3/24.
//

import SwiftUI

struct PredictionView: View {
    let prediction: Prediction

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ExpandableCardView(title: "General", desc: prediction.general)
                ExpandableCardView(title: "Personal", desc: prediction.personal)
                ExpandableCardView(title: "Finance", desc: prediction.finance)
                ExpandableCardView(title: "Health", desc: prediction.health)
                
                let nums = prediction.luckyNumbers
                   let filtered = nums.map({$0.description}).joined(separator: ", ")
                ExpandableCardView(title: "Lucky Numbers", desc: filtered)
                
                let colss = prediction.luckyColors
                    let cols = colss.map({$0.description}).joined(separator: ", ")
                ExpandableCardView(title: "Lucky Colors", desc: cols)
            }
        }
        .navigationTitle("Prediction")
    }
}
#Preview {
    HoroscopeMainPageView()
}
