//
//  BannerAdView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/13/24.
//

import SwiftUI
import UIKit
import GoogleMobileAds

struct BannerAd320x50View: View {
    var body: some View {
        AdBannerView(adUnitID: "ca-app-pub-3694736860349569/3932435138")
            .frame(width: 320, height: 50, alignment: .center)
    }
}

struct BannerAd320x100View: View {
    var body: some View {
        AdBannerView(adUnitID: "ca-app-pub-3694736860349569/3932435138")
            .frame(width: 320, height: 100, alignment: .center)
    }
}
    // UIViewRepresentable wrapper for AdMob banner view
    struct AdBannerView: UIViewRepresentable {
        let adUnitID: String

        func makeUIView(context: Context) -> BannerView {
            let banner = BannerView(adSize: adSizeFor(cgSize: CGSize(width: 320, height: 50)))
               banner.adUnitID = adUnitID
               banner.rootViewController = UIApplication.shared.connectedScenes
                   .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                   .first?.rootViewController
               banner.load(Request())
               return banner
           }
        func updateUIView(_ uiView: BannerView, context: Context) {}
    }


#Preview {
    BannerAd320x50View()
}
