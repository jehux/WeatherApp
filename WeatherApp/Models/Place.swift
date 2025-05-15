//
//  Place.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import Foundation
import UIKit

struct Place: Codable, Identifiable {
    var id: Int
    var licence: String?
    var osmType: String?
    var osmId: Int?
    var lat: String
    var lon: String
    var placeClass: String?
    var type: String?
    var placeRank: Int?
    var importance: Double?
    var addressType: String?
    var name: String
    var displayName: String
    var boundingBox: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case licence
        case osmType = "osm_type"
        case osmId = "osm_id"
        case lat
        case lon
        case placeClass = "class"
        case type
        case placeRank = "place_rank"
        case importance
        case addressType = "addresstype"
        case name
        case displayName = "display_name"
        case boundingBox = "boundingbox"
    }
}
