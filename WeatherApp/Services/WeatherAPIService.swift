//
//  WeatherAPIService.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import Foundation
import Combine
import PulseProxy
import Pulse

final class WeatherAPIService: APIServiceType {

    internal let baseURL: String
    internal let session: URLSession = URLSession.shared
    internal let uiQueue: DispatchQueue = DispatchQueue.main

    init(baseURL: String =  "https://api.open-meteo.com/v1/forecast") {
        self.baseURL = baseURL
        NetworkLogger.enableProxy()
    }
 
    func call<Request>(from endpoint: Request) -> AnyPublisher<Request.ModelType, Error> where Request : APIRequestType {
        do {
            print("Enviar peticion")
            let request = try endpoint.buildRequest(baseURL: baseURL)
            return session.dataTaskPublisher(for: request)
                .retry(1)
                .tryMap {
                    print("respuesta recibida")
                    guard let code = ($0.response as? HTTPURLResponse)?.statusCode else {
                        throw APIServiceError.unexpectedResponse
                    }
                    guard HTTPCodes.success.contains(code) else {
                        throw APIServiceError.httpError(code)
                    }
                    return $0.data  // Pass data to downstream publishers
                }
                .decode(type: Request.ModelType.self, decoder: JSONDecoder())
                .mapError {_ in APIServiceError.parseError}
                .receive(on: self.uiQueue)
                .eraseToAnyPublisher()
        } catch let error {
            return Fail<Request.ModelType, Error>(error: error).eraseToAnyPublisher()
        }
    }
    
}
