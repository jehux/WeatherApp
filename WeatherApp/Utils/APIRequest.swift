//
//  APIRequest.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import Foundation

protocol APIRequestType {
    associatedtype ModelType: Decodable

    var path: String {get}
    var method: String {get}
    var headers: [String: String]? {get}
    var queryItems: [URLQueryItem]? {get}
    func body() throws -> Data?
}

extension APIRequestType {
    func buildRequest(baseURL: String) throws -> URLRequest {

        guard let url = URL(string: baseURL + path) else {
            throw APIServiceError.invalidURL
        }
        print("peticion hacia: \(url.absoluteString)")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}

struct WeatherRequest: APIRequestType {
    typealias ModelType = PlacesListResponse
    
    var path: String
    var method: String { return "GET" }
    var headers: [String: String]? { return ["Content-Type": "application/json"] }
    var queryItems: [URLQueryItem]?
    func body() throws -> Data? {
        return Data()
    }
}

struct PlacesListRequest: APIRequestType {
    typealias ModelType = [Place]

    var path: String
    var method: String { return "GET" }
    var headers: [String: String]? { return ["Accept": "application/json",
                                             "User-Agent": "WeatherApp/1.0 (jehunego@gmail.com)"] }
    var queryItems: [URLQueryItem]?
    func body() throws -> Data? {
        return Data()
    }
}

struct ImageRequest: APIRequestType {
    typealias ModelType = Data
    
    var path: String
    var method: String { return "GET" }
    var headers: [String : String]?
    var queryItems: [URLQueryItem]?
    func body() throws -> Data? {
        return Data()
    }
}
