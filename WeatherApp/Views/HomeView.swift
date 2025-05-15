//
//  HomeView.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import SwiftUI
import PulseUI
import Pulse

struct HomeView: View {
    @ObservedObject private(set) var homeViewModel: HomeViewModel
    @State private var selectedPlace: String? = nil
    @State private var placeName: String = ""
    @State private var goToAddPlace: Bool = false
    @State private var places: [Place] = []
    @State private var mostrarInfo = false
    @State private var showPulse = false

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // Header superior
                HStack {
                    Text("\(homeViewModel.temperature)°")
                        .font(.system(size: 64, weight: .bold))

                    Spacer()

                    Button(action: {
                        print("Abrir pulse")
                        showPulse = true
                    }) {
                        Image(systemName: "globe")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.brown)
                            .clipShape(Circle())
                    }.sheet(isPresented: $showPulse) {
                        ConsoleView()
                    }

                    Button(action: {
                        print("presiono boton")
                        goToAddPlace = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.brown)
                            .clipShape(Circle())
                    }
                }.navigationDestination(isPresented: $goToAddPlace) {
                    PlaceSearchView(placeSearchViewModel: .init(context: viewContext))
                }

                // Bienvenida
                VStack(alignment: .leading, spacing: 4) {
                    Text(placeName)
                        .font(.title3)
                        .bold()
                    Text("Bienvenido a datos del clima:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Mas info de clima
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Image(systemName: homeViewModel.isDaytime ? "sun.max.fill" : "moon.fill")
                                .font(.system(size: 40))
                                .foregroundColor(homeViewModel.isDaytime ? .yellow : .blue)
                            Text(homeViewModel.isDaytime ? "Día" : "Noche")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        VStack(spacing: 8) {
                            Image(systemName: "wind")
                                .font(.system(size: 40))
                                .foregroundColor(.cyan)
                            Text("viento \(homeViewModel.windspeed) km/h")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                }

                HStack(spacing: 16) {
                    Image(selectedPlace ?? "Image_default")
                        .resizable()
                }

                // favoritos header
                Spacer()
                HStack {
                    Text("Clima en tus ciudades")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        mostrarInfo = true
                    }) {
                        Image(systemName: "info.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $mostrarInfo) {
                        OwnerInfoViewControllerWrapper()
                    }
                }

                // Scroll horizontal de favoritos
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(places.enumerated()), id: \.offset) { index, place in
                            let imageName = homeViewModel.imagesList[index > homeViewModel.imagesList.count ? 0 : index]
                            RoomCard(imageName: imageName, placeName: place.name) {
                                selectedPlace = imageName
                                placeName = place.displayName
                                homeViewModel.place = place
                                homeViewModel.update()
                            }
                        }
                    }
                }

            }
            .padding()
            .onAppear(perform: {
                let res = homeViewModel.fetchAllPlaces(context: viewContext)
                var savedPlaces: [Place] = []
                for place in res {
                    let metaPlace = Place(id: Int(place.id),
                                          lat: place.latitude ?? "",
                                          lon: place.longitude ?? "",
                                          name: place.name ?? "",
                                          displayName: place.displayName ?? "")
                    savedPlaces.append(metaPlace)
                }
                self.places = savedPlaces
                print("recolectado exitosamente")
            })
        }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(homeViewModel: .init())
    }
}
