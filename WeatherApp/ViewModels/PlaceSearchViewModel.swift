//
//  PlaceSearchViewModel.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import Foundation
import Combine
import SwiftUI
import CoreData

final class PlaceSearchViewModel: ObservableObject {
    private var cancellables: [AnyCancellable] = []
    
    private let onAppearSubject = PassthroughSubject<Void, Error>()

    private let placesService: APIServiceType
    private let context: NSManagedObjectContext

    // Publish values on-demand by calling the send() method
    func update() {
        onAppearSubject.send(())
        //objectWillChange.send()
    }

    @Published var places: [Place] = []

    @Published var isErrorShown = false
    @Published var errorMessage = ""
    @Published var query: String = ""

    @Published var isLoading: Bool = false
    
    init(placesService: APIServiceType = PlacesAPIService(), context: NSManagedObjectContext) {
        self.placesService = placesService
        self.context = context
        fetchPlace()
        print("------- PlaceSearch view model init done ---------")
    }

    private func fetchPlace() {
        onAppearSubject
                .flatMap { [unowned self] _ -> AnyPublisher<[Place], Error> in
                    let queryEncoded = self.query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    let endpoint = PlacesListRequest(path: "search?q=\(queryEncoded)&format=json")
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

    public func saveToCoreData(_ place: Place) {
            let entity = PlaceEntity(context: context)
            entity.id = Int64(place.id)
            entity.name = place.name
            entity.displayName = place.displayName
            entity.latitude = place.lat
            entity.longitude = place.lon
        do {
            try context.save()
            print("✅ place guardardo en Core Data")
        } catch let error as NSError {
            print("❌ Error al guardar: \(error), \(error.userInfo)")
        }
    }

}
