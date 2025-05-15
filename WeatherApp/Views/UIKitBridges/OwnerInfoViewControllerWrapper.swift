//
//  OwnerInfoViewControllerWrapper.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import SwiftUI

struct OwnerInfoViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> InfoViewController {
        return InfoViewController()
    }

    func updateUIViewController(_ uiViewController: InfoViewController, context: Context) {
    }
}
