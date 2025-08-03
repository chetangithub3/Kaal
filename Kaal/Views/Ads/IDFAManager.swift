//
//  IDFAManager.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 8/3/25.
//

import Foundation
import AppTrackingTransparency
import AdSupport

final class IDFAManager {
    static let shared = IDFAManager()
    private init() {}
    
    /// Requests tracking authorization and fetches the IDFA
    func requestIDFA(completion: @escaping (String?) -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        completion(idfa)
                    } else {
                        completion(nil) // Not authorized
                    }
                }
            }
        } else {
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            completion(idfa)
        }
    }
    
    /// Gets the current IDFA without prompting (will return zeros if not authorized)
    func getIDFA() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}
