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
                ProgressView("Fetching data")
            } else if let prediction = viewModel.prediction{
                PredictionView(prediction: prediction)
            }
        }
        .padding()
        .task {
            if viewModel.needsNewFetch() {
                await viewModel.fetchPrediction()
            }
        }
    }
}

#Preview {
    HoroscopeMainPageView()
}
