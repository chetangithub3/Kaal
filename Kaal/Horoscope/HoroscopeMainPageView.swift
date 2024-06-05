//
//  HoroscopeView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/22/24.
//

import SwiftUI

struct HoroscopeMainPageView: View {
    @StateObject private var viewModel = HoroscopeViewModel()
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if let prediction = viewModel.prediction{
                    PredictionView(prediction: prediction)
                } else {
                    Text(viewModel.horoscope)
                }
            }
        }
        .padding()
        .task {
            guard viewModel.prediction != nil else {
                await viewModel.fetchPrediction()
                return
            }
        }
    }
}

#Preview {
    HoroscopeMainPageView()
}
