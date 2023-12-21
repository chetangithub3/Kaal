//
//  AddressesListResponse.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/20/23.
//


import Foundation

// MARK: - AddressesListResponseElement
struct AddressesListResponseElement: Codable {
    var lat, lon, displayName: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case lat, lon
        case displayName = "display_name"
        case type
    }
}

typealias AddressesListResponse = [AddressesListResponseElement]
