//
//  RoomCard.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import SwiftUI

struct RoomCard: View {
    var imageName: String
    var placeName: String
    var onTap: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 220)
                .clipped()
                .cornerRadius(20)
                .overlay(
                    Color.black.opacity(0.4)
                        .cornerRadius(20)
                )

            Text(placeName)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
        }
        .onTapGesture {
                    onTap?()
                }
    }
}
