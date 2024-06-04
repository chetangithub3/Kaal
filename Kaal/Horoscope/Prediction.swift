//
//  Prediction.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 6/3/24.
//

import Foundation
struct  Prediction {
    let id = UUID()
    let dateString: String
    let general: String
    let personal: String
    let finance: String
    let health: String
    let social: String
    let luckyNumbers: [Int]
    let luckyColors: [String]
}

