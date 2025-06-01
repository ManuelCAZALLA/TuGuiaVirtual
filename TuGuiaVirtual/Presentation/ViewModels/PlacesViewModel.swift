//
//  PlacesViewModel.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 25/5/25.
//

import Foundation
import CoreLocation

class PlacesViewModel: ObservableObject {
    @Published var places: [GeoapifyPlace] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let locationManager = LocationManager()
    private let service = GeoapifyPlacesService()
    
    func loadPlaces(latitude: Double, longitude: Double, category: String = "entertainment") {
        isLoading = true
        errorMessage = nil
        
        let coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        service.fetchNearbyPlaces(location: coords, category: category) { [weak self] fetchedPlaces in
            DispatchQueue.main.async {
                self?.isLoading = false
                if fetchedPlaces.isEmpty {
                    self?.errorMessage = "No se encontraron lugares."
                    self?.places = []
                } else {
                    self?.places = fetchedPlaces
                }
            }
        }
    }
    
    func searchPlacesByCity(cityName: String, category: String) {
        isLoading = true
        errorMessage = nil
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let coordinate = placemarks?.first?.location?.coordinate {
                    self.loadPlaces(latitude: coordinate.latitude, longitude: coordinate.longitude, category: category)
                } else {
                    self.isLoading = false
                    self.errorMessage = "No se pudo encontrar la ciudad '\(cityName)'."
                    self.places = []
                }
            }
        }
    }
    
    func searchPlacesNearby(category: String) {
            guard let location = locationManager.userLocation else {
                self.errorMessage = "No se pudo obtener tu ubicación actual."
                return
            }

            self.loadPlaces(latitude: location.latitude, longitude: location.longitude, category: category)
        }

}
