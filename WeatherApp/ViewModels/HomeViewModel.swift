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
    
    private let placesService: APIServiceType

    // Publish values on-demand by calling the send() method
    func update() {
        onAppearSubject.send(())
        //objectWillChange.send()
    }
    
    private var places: [Place] = []
    
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    @Published var place: Place? = nil
    @Published var isLoading: Bool = false
    
    init(placesService: APIServiceType = PlacesAPIService()) {
        self.placesService = placesService

        fetchWeather()
        print("------- Home view model init done ---------")
    }

    private func fetchWeather() {
        onAppearSubject
                .flatMap { [unowned self] _ -> AnyPublisher<[Place], Error> in
                    let latitude = self.place?.lat.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    let longitude = self.place?.lon.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    let endpoint = PlacesListRequest(path: "?latitude=\(latitude)&longitude=\(longitude)&current_weather=true")
                    self.isLoading = true
                    return self.placesService.call(from: endpoint)
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    self.isLoading = false
                    switch completion {
                    case .failure(let error): do {
                        self.errorMessage = error.localizedDescription
                        self.isErrorShown = true
                        }
                    case .finished:
                        break
                    }
                }, receiveValue: { (places) in
                    self.isLoading = false
                    self.places = places
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
