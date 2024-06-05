//
//  PredictionModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 6/4/24.
//

import Foundation
import SwiftData

@Model
class  PredictionModel {
    let id = UUID()
    let dateString: String
    let general: String
    let personal: String
    let finance: String
    let health: String
    let social: String
    let luckyNumbers: [Int]
    let luckyColors: [String]
    
    init(dateString: String, general: String, personal: String, finance: String, health: String, social: String, luckyNumbers: [Int], luckyColors: [String]) {
        self.dateString = dateString
        self.general = general
        self.personal = personal
        self.finance = finance
        self.health = health
        self.social = social
        self.luckyNumbers = luckyNumbers
        self.luckyColors = luckyColors
    }
}
