//
//  PlaceView.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 25/5/25.
//

import SwiftUI
import CoreLocation

struct PlacesView: View {
    @StateObject private var viewModel = PlacesViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var cityInput: String = ""
    @State private var selectedCategory: PlaceCategory = .bar
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.backgroundGradientStart, .backgroundGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Barra de búsqueda
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Introduce una ciudad", text: $cityInput)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .padding(.horizontal)

                        CategorySelectorView(selectedCategory: $selectedCategory)
                            .padding(.horizontal)

                        HStack(spacing: 12) {
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
                    }
                    .padding(.top)

                    if let error = viewModel.errorMessage {
                        Text("⚠️ \(error)")
                            .foregroundColor(.red)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.1))
                            )
                            .padding(.horizontal)
                    }

                    if viewModel.isLoading {
                        LoadingIndicator()
                            .padding()
                    } else {
                        List(viewModel.places) { place in
                            NavigationLink(destination: PlaceDetailView(viewModel: PlaceDetailViewModel(place: GeoapifyFeature(properties: place, geometry: Geometry(coordinates: [place.longitude ?? 0, place.latitude ?? 0])), userLocation: locationManager.userLocation))) {
                                HStack(spacing: 16) {
                                    Image(systemName: selectedCategory.emoji)
                                        .font(.title2)
                                        .foregroundColor(.accentColor)
                                        .frame(width: 40, height: 40)
                                        .background(
                                            Circle()
                                                .fill(Color.accentColor.opacity(0.1))
                                        )

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(place.name ?? "Sin nombre")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        HStack {
                                            Image(systemName: "location.fill")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Text("\(place.street ?? "") \(place.city ?? "")")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Guía Virtual")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: PlanGeneratorView()) {
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

#Preview {
    PlacesView()
}


