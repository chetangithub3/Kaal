//
//  Extensions.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 1/5/24.
// https://www.termsfeed.com/live/53b19986-13af-451c-a59e-726efa238cd7

import Foundation
import SwiftUI
import UIKit

extension UIView {
    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
    
    func takeScreenshot(afterScreenUpdates: Bool) -> UIImage {
        if !self.responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))) {
            return self.takeScreenshot()
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
}

extension View {
   
    func takeScreenshot(frame:CGRect, afterScreenUpdates: Bool) -> UIImage {
        let hosting = UIHostingController(rootView: self)
        hosting.overrideUserInterfaceStyle = UIApplication.shared.currentUIWindow()?.overrideUserInterfaceStyle ?? .unspecified
        hosting.view.frame = frame
        return hosting.view.takeScreenshot(afterScreenUpdates: afterScreenUpdates)
    }
    
    func getTintColor() -> Color {
        return Color(red: 196 / 255.0, green: 134 / 255.0, blue: 18 / 255.0)
    }
    
    func getBackgroundColor() -> Color{
        return Color(red: 242 / 255.0, green: 242 / 255.0, blue: 247 / 255.0)
    }
}

extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }
        
        return window
    }
}

enum NetworkStatus: String {
    case connected
    case disconnected
}


enum APIError: Error {
    case notFound
    case badServer
    case unhandled(Error)
}


enum TimeIntervalNature {
    case auspicious
    case inauspicious
    case neutral
}

extension TimeIntervalNature {
    
    var description: String {
        switch self {
            case .auspicious:
                return "Auspicious"
            case .inauspicious:
                return "Inauspicious"
            case .neutral:
                return "Neutral"
        }
    }
    var color: Color {
        switch self {
        case .auspicious:
            return Color(red: 58 / 255.0, green: 95 / 255.0, blue: 11 / 255.0)
        case .inauspicious:
            return Color(red: 179 / 255.0, green: 27 / 255.0, blue: 27 / 255.0)
        case .neutral:
            return Color(red: 255 / 255.0, green: 196 / 255.0, blue: 12 / 255.0)
        }
    }
}

enum Kaal: String {
    case abhijit 
    case brahma
    case rahu
    case yama
}

extension Kaal {
    var title : String {
        
        switch self {
                
            case .abhijit:
                return "Abhijit Kaala"
            case .brahma:
                return "Brahma Muhurta"
            case .rahu:
                return "Rahu Kaala"
            case .yama:
                return "Yama Ganda"
        }
    }
    var nature: TimeIntervalNature {
        switch self {
        case .abhijit, .brahma:
            return .auspicious
        case .yama, .rahu:
            return .inauspicious
        }
    }

    var color: Color {
        return nature.color
    }
}
enum LocationItemTheme {
    case underlined
    case button
}


