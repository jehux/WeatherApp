//
//  AddPlaceView.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import SwiftUI

struct PlaceSearchView: View {
    @ObservedObject private(set) var placeSearchViewModel: PlaceSearchViewModel
    @State private var searchText: String = ""

    let recentSearches = [
        ("UX/UI Designer", "İstanbul, Avrupa"),
        ("Ürün Yöneticisi", "İstanbul, Asya"),
        ("Satış Danışmanı", "Ankara, Çankaya")
    ]

    var body: some View {
        VStack(spacing: 16) {
            // Buscador
            TextField("Ejem. CDMX", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .onSubmit {
                        placeSearchViewModel.query = searchText
                        placeSearchViewModel.update()
                    }

            // Título
            HStack {
                Text("Resultado")
                    .font(.headline)
                    .padding(.horizontal)
                Spacer()
            }
            if placeSearchViewModel.isLoading {
                ProgressView("Buscando...")
                    .padding()
            }
            // Lista de resultados
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(placeSearchViewModel.places, id: \.id) { place in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(place.displayName)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(place.name)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "heart")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                        .onTapGesture(perform: {
                            placeSearchViewModel.saveToCoreData(place)
                        })
                    }
                }
            }
        }
        .padding(.top)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Buscar nuevo lugar")
    }
}
