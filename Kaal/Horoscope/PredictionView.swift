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
                Text("General").font(.headline)
                Text(prediction.general).padding(.bottom, 10)
                
                Text("Personal").font(.headline)
                Text(prediction.personal).padding(.bottom, 10)
                
                Text("Finance").font(.headline)
                Text(prediction.finance).padding(.bottom, 10)
                
                Text("Health").font(.headline)
                Text(prediction.health).padding(.bottom, 10)
                
                Text("Social").font(.headline)
                Text(prediction.social).padding(.bottom, 10)
                
                Text("Lucky Numbers").font(.headline)
               
                if let nums = prediction.luckyNumbers {
                    let filtered = nums.map({$0.description}).joined(separator: ", ")
                    Text(filtered)
                }
                Text("Lucky Colors").font(.headline)
                if let nums = prediction.luckyColors  {
                    let filtered = nums.map({$0.description}).joined(separator: ", ")
                    Text(filtered)
                }
               
            }
            .padding()
        }
        .navigationTitle("Prediction")
    }
}
