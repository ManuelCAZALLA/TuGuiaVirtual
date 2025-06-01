//
//  PlaceView.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 25/5/25.
//

import SwiftUI

struct PlacesView: View {
    @StateObject private var viewModel = PlacesViewModel()
    @State private var cityInput: String = "Fuengirola"
    @State private var selectedCategory: PlaceCategory = .bar

    var body: some View {
        NavigationView {
            ZStack {
                // Fondo con gradiente 
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
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

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(PlaceCategory.allCases) { category in
                                    Button(action: {
                                        selectedCategory = category
                                    }) {
                                        Text("\(category.emoji) \(category.displayName)")
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(selectedCategory == category ? Color.blue.opacity(0.8) : Color.white)
                                            .foregroundColor(selectedCategory == category ? .white : .black)
                                            .cornerRadius(20)
                                            .shadow(radius: 2)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        Button(action: {
                            viewModel.searchPlacesByCity(cityName: cityInput, category: selectedCategory.rawValue)
                        }) {
                            Text("Buscar lugares")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                        }
                        .padding(.horizontal)
                    }

                    if let error = viewModel.errorMessage {
                        Text("⚠️ \(error)")
                            .foregroundColor(.red)
                            .padding()
                    }

                    List(viewModel.places) { place in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(place.name ?? "Sin nombre")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("\(place.street ?? "") \(place.city ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                    .listStyle(.plain)
                    .background(Color.clear)
                }
                .padding(.top)
            }
            .navigationTitle("Guía Virtual")
        }
    }
}

#Preview {
    PlacesView()
}


