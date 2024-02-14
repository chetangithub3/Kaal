//
//  AppDelegate.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 2/13/24.
//

import Foundation
import UIKit
import GoogleMobileAds

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    
    return true
  }

}
