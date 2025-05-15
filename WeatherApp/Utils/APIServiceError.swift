//
//  APIServiceError.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import Foundation

enum APIServiceError: Error {
    case invalidURL
    case httpError(HTTPCode)
    case parseError
    case unexpectedResponse
}

extension APIServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpError(statusCode): return "Unexpected HTTP status code: \(statusCode)"
        case .parseError: return "Unexpected JSON parse error"
        case .unexpectedResponse: return "Unexpected response from the server"
        }
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
