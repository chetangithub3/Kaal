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
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Fetching data")
            } else if let prediction = viewModel.prediction {
                ProfileView()
                PredictionView(prediction: prediction)
            }
        }.task {
            if viewModel.needsNewFetch() {
                await viewModel.fetchPrediction()
            }
        }
    }
}

#Preview {
    HoroscopeMainPageView()
}


