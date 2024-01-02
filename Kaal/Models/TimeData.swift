//
//  TimeData.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/24/23.
//

import Foundation
    // MARK: - TimeData
struct TimeData: Codable {
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
}


    // MARK: - Sys
struct Sys: Codable {
    let sunrise, sunset: Int?
}
