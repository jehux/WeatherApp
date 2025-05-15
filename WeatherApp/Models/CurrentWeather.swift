//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import Foundation

struct CurrentWeather: Codable {
    let time: String
    let interval: Int
    let temperature: Double
    let windspeed: Double
    let winddirection: Int
    let isDay: Int
    let weathercode: Int

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
