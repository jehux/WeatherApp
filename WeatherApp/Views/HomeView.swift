//
//  HomeView.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import SwiftUI

struct HomeView: View {
    //@ObservedObject private(set) var HomeViewModel: HomeViewModel
    @State private var selectedPlace: String? = nil
    @State private var placeName: String = "Apatlaco"
    @State private var goToAddPlace: Bool = false

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // Header superior
                HStack {
                    Text("27°")
                        .font(.system(size: 64, weight: .bold))

                    Spacer()

                    Button(action: {
                        // Acción del botón "+"
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
                    Text("Bienvenido datos del clima:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Avatares
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<3) { index in
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }

                        Button(action: {}) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(10)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                    }
                }

                HStack(spacing: 16) {
                    Image(selectedPlace ?? "Image_default")
                        .resizable()
                }

                // All Rooms header
                Spacer()
                HStack {
                    Text("Clima en tus ciudades")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }

                // Scroll horizontal de cuartos
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        RoomCard(imageName: "spain", placeName: "España") {
                            selectedPlace = "spain"
                            placeName = "España"
                        }
                        RoomCard(imageName: "Image_default", placeName: "Random")
                        RoomCard(imageName: "Image_default", placeName: "Apatlaco")
                    }
                }

            }
            .padding()
        }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
