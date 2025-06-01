//
//  PlaceView.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 25/5/25.
//

import SwiftUI

import SwiftUI
import CoreLocation

struct PlacesView: View {
    @StateObject private var viewModel = PlacesViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var cityInput: String = ""
    @State private var selectedCategory: PlaceCategory = .bar

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.backgroundGradientStart, .backgroundGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        TextField("Introduce una ciudad", text: $cityInput)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.horizontal)

                        CategorySelectorView(selectedCategory: $selectedCategory)

                        SearchButton {
                            viewModel.searchPlacesByCity(cityName: cityInput, category: selectedCategory.rawValue)
                        }

                        NearbyButton {
                            if let location = locationManager.userLocation {
                                viewModel.loadPlaces(latitude: location.latitude, longitude: location.longitude, category: selectedCategory.rawValue)
                            } else {
                                viewModel.errorMessage = "Ubicación no disponible o sin permisos."
                            }
                        }
                    }

                    if let error = viewModel.errorMessage {
                        Text("⚠️ \(error)")
                            .foregroundColor(.red)
                            .padding()
                    }

                    List(viewModel.places) { place in
                        VStack(alignment: .leading) {
                            Text(place.name ?? "Sin nombre")
                                .font(.headline)
                            Text("\(place.street ?? "") \(place.city ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                    .listStyle(.plain)
                }
                .padding(.top)
            }
            .navigationTitle("Guía Virtual")
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

#Preview {
    PlacesView()
}


