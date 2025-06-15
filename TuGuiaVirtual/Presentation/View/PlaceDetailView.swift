//
//  PlaceDetailView.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 11/6/25.
//

import SwiftUI
import CoreLocation

struct PlaceDetailView: View {
    @ObservedObject var viewModel: PlaceDetailViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
               
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.place.properties.name ?? "Nombre no disponible")
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.accentColor)
                        Text("\(viewModel.distanceFormatted) desde tu ubicación")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 8)

                // Información de dirección
                VStack(alignment: .leading, spacing: 12) {
                    Text("Dirección")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if let street = viewModel.place.properties.street {
                            HStack {
                                Image(systemName: "map.fill")
                                    .foregroundColor(.accentColor)
                                Text(street)
                                    .foregroundColor(.primary)
                            }
                        }
                        if let city = viewModel.place.properties.city {
                            HStack {
                                Image(systemName: "building.2.fill")
                                    .foregroundColor(.accentColor)
                                Text(city)
                                    .foregroundColor(.primary)
                            }
                        }
                        if let country = viewModel.place.properties.country {
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.accentColor)
                                Text(country)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray6))
                    )
                }

                // Botón de navegación
                if let mapsURL = viewModel.googleMapsURL {
                    VStack(spacing: 16) {
                        Link(destination: mapsURL) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("Cómo llegar con Google Maps")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                        }
                        
                        Text("Se abrirá en Google Maps con indicaciones paso a paso")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.backgroundGradientStart, .backgroundGradientEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    let samplePlace = GeoapifyPlace(
        placeId: "123",
        name: "Café Central",
        street: "Gran Vía 123",
        city: "Madrid",
        country: "España",
        latitude: 40.4168,
        longitude: -3.7038
    )
    
    let feature = GeoapifyFeature(
        properties: samplePlace,
        geometry: Geometry(coordinates: [samplePlace.longitude ?? 0, samplePlace.latitude ?? 0])
    )
    
    return NavigationView {
        PlaceDetailView(viewModel: PlaceDetailViewModel(
            place: feature,
            userLocation: CLLocationCoordinate2D(latitude: 40.4168, longitude: -3.7038)
        ))
    }
}
