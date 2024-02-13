//
//  BannerAdView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/13/24.
//

import SwiftUI
import UIKit
import GoogleMobileAds

struct BannerAdView: View {
    var body: some View {
        AdBannerView(adUnitID: "ca-app-pub-3694736860349569/3932435138")
            .frame(width: getScreenBounds().width - 30, height: 50, alignment: .center)
    }
}

    // UIViewRepresentable wrapper for AdMob banner view
    struct AdBannerView: UIViewRepresentable {
        let adUnitID: String

        func makeUIView(context: Context) -> GADBannerView {
            let bannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: getScreenBounds().width - 30, height: 200))) // Set your desired banner ad size
            bannerView.adUnitID = adUnitID
            bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
            
            bannerView.load(GADRequest())
            return bannerView
        }
        
        func updateUIView(_ uiView: GADBannerView, context: Context) {}
    }


#Preview {
    BannerAdView()
}
