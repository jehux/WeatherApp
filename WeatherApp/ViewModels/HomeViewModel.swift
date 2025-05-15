//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import Foundation
import Combine
import SwiftUI
import CoreData

final class HomeViewModel: ObservableObject {
    private var cancellables: [AnyCancellable] = []
    
    private let onAppearSubject = PassthroughSubject<Void, Error>()
    
    private let weatherService: APIServiceType

    // Publish values on-demand by calling the send() method
    func update() {
        onAppearSubject.send(())
        //objectWillChange.send()
    }
    
    @Published var place: Place? = nil
    
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    @Published var temperature = ""
    @Published var weather: WeatherResponse? = nil
    @Published var isLoading: Bool = false
    @Published var isDaytime: Bool = false
    @Published var windspeed: String = ""
    @Published var windsUnit: String = ""
    @Published var imagesList = ["tokio","argentina", "mumbai", "buenos_aires", "cape_town", "florencia", "Image_default", "reykjavik", "spain", "vancouver"]
    
    init(weatherService: APIServiceType = WeatherAPIService()) {
        self.weatherService = weatherService

        fetchWeather()
        print("------- Home view model init done ---------")
    }

    func fetchWeather() {
        onAppearSubject
                .flatMap { [unowned self] _ -> AnyPublisher<WeatherResponse, Error> in
                    let latitude = self.place?.lat.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    let longitude = self.place?.lon.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    let endpoint = WeatherRequest(path: "?latitude=\(latitude)&longitude=\(longitude)&current_weather=true")
                    self.isLoading = true
                    return self.weatherService.call(from: endpoint)
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    self.isLoading = false
                    switch completion {
                    case .failure(let error): do {
                        self.errorMessage = error.localizedDescription
                        self.isErrorShown = true
                        print(self.errorMessage)
                        }
                    case .finished:
                        break
                    }
                }, receiveValue: { (weather) in
                    self.isLoading = false
                    self.weather = weather
                    self.temperature = String(weather.currentWeather.temperature)
                    self.isDaytime = weather.currentWeather.isDay == 1
                    self.windspeed = String(weather.currentWeather.windspeed)
                    self.windsUnit = String(weather.currentWeatherUnits.windspeed)
                })
                .store(in: &cancellables)
    }

    func fetchAllPlaces(context: NSManagedObjectContext) -> [PlaceEntity] {
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print("❌ Error al obtener los lugares: \(error.localizedDescription)")
            return []
        }
    }

}
