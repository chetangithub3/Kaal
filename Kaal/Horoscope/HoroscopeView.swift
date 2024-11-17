//
//  HoroscopeView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/26/24.
//

import SwiftUI

struct HoroscopeView: View {
    @AppStorage("horoscopeObDone") var horoscopeObDone: Bool = false
    var body: some View {
        if !horoscopeObDone {
            NavigationStack {
              HoroscopeOnboardingView()
            }
        } else {
            NavigationStack {
                HoroscopeMainPageView()
                    .navigationTitle("Horoscope")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    HoroscopeView()
}
