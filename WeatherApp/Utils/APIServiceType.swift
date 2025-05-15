//
//  APIServiceType.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import Foundation
import Combine

protocol APIServiceType {
    var session: URLSession {get}
    var baseURL: String {get}
    var uiQueue: DispatchQueue {get}
    func call<Request>(from endpoint: Request) -> AnyPublisher<Request.ModelType, Error> where Request: APIRequestType
}
