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
            if let prediction = viewModel.prediction{
                PredictionView(prediction: prediction)
            } else {
                Text(viewModel.horoscope ?? "")
            }
        }
        .padding()
        .task {
            await viewModel.fetchHoroscope()
        }
    }
}

#Preview {
    HoroscopeMainPageView()
}
