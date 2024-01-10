//
//  NetworkManager.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 1/9/24.
//

import Foundation
import Reachability
import Network



class NetworkManager {
    static let shared = NetworkManager()
    private let reachability = try! Reachability()
    
    var isNetworkAvailable: Bool {
        return reachability.connection != .unavailable
    }
    
    func startMonitoring() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
    }
}
