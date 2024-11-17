//
//  Extensions.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 1/5/24.
// https://www.termsfeed.com/live/53b19986-13af-451c-a59e-726efa238cd7

import Foundation
import SwiftUI
import UIKit

extension View {
    func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
extension View {

    func onBackground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
            perform: { _ in f() }
        )
    }
    
    func onForeground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
            perform: { _ in f() }
        )
    }
  
}

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

extension ViewModifier {
    func getTintColor() -> Color {
        return Color(red: 196 / 255.0, green: 134 / 255.0, blue: 18 / 255.0)
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

enum Kaal {
    case abhijit 
    case brahma
    case rahu
    case yama
    case gulika
}

extension Kaal {
    var title : String {
        
        switch self {
            case .abhijit:
                return "Abhijit Muhurta"
            case .brahma:
                return "Brahma Muhurta"
            case .rahu:
                return "Rahu Kaala"
            case .yama:
                return "Yama Kaala"
            case .gulika:
                return "Gulika Kaala"
        }
    }
    var nature: TimeIntervalNature {
        switch self {
        case .abhijit, .brahma:
            return .auspicious
            case .yama, .rahu, .gulika:
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


enum Choghadiya: String {
    case udveg = "Udveg"
    case amrit = "Amrit"
    case rog = "Rog"
    case labh = "Labh"
    case shubh = "Shubh"
    case char = "Char"
    case kaal = "Kaal"
}

extension Date {
    
    func toStringVersion(dateFormat: String ,timezone: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timezone)
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}
extension Choghadiya {
    
    var nature: ChoghadiyaNature {
        switch self {
            case .udveg: return .bad
            case .amrit: return .best
            case .rog: return .evil
            case .labh: return .gain
            case .shubh: return .good
            case .char: return .neu
            case .kaal: return .bad
        }
    }
}

enum ChoghadiyaNature {
    case best
    case good
    case gain
    case neu
    case loss
    case bad
    case evil
    
    var title: String {
        switch self {
                
            case .best:
                return "Best"
            case .good:
                return "Good"
            case .gain:
                return "Gain"
            case .neu:
                return "Neutral"
            case .loss:
                return "Loss"
            case .bad:
                return "Bad"
            case .evil:
                return "Evil"
        }
    }
    var color: Color {
        switch self {
            case .best:
                return Color(red: 58 / 255.0, green: 95 / 255.0, blue: 11 / 255.0)
            case .good:
                return Color(red: 58 / 255.0, green: 95 / 255.0, blue: 11 / 255.0)
            case .gain:
                return Color(red: 58 / 255.0, green: 95 / 255.0, blue: 11 / 255.0)
            case .neu:
                return Color(red: 255 / 255.0, green: 196 / 255.0, blue: 12 / 255.0)
            case .loss:
                return Color(red: 179 / 255.0, green: 27 / 255.0, blue: 27 / 255.0)
            case .bad:
                return Color(red: 179 / 255.0, green: 27 / 255.0, blue: 27 / 255.0)
            case .evil:
                return Color(red: 179 / 255.0, green: 27 / 255.0, blue: 27 / 255.0)
        }
    }
}
extension Color {
    init(hex: UInt) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

extension Data {
    func printJSON(debugTitle: String) {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            dump(JSONString, name: "JSONString")
        }
    }
}

enum Gender: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    case preferNotToSay = "Prefer not to say"

    var id: String { self.rawValue }
}

extension String {
    func trimFirstAndLastSpaces() -> String {
        var trimmedString = self
        
        if trimmedString.hasPrefix(" ") {
            trimmedString.removeFirst()
        }
        
        if trimmedString.hasSuffix(" ") {
            trimmedString.removeLast()
        }
        
        return trimmedString
    }
}
