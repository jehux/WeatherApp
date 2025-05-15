//
//  CurrentWeatherUnits.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import Foundation

struct CurrentWeatherUnits: Codable {
    let time: String
    let interval: String
    let temperature: String
    let windspeed: String
    let winddirection: String
    let isDay: String
    let weathercode: String

    enum CodingKeys: String, CodingKey {
        case time
        case interval
        case temperature
        case windspeed
        case winddirection
        case isDay = "is_day"
        case weathercode
    }
}
