//
//  PlacesDetailViewModel.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 11/6/25.
//

import Foundation
import CoreLocation

class PlaceDetailViewModel: ObservableObject {
    @Published var place: GeoapifyFeature
    @Published var distanceInMeters: Double?

    private var userLocation: CLLocationCoordinate2D?

    init(place: GeoapifyFeature, userLocation: CLLocationCoordinate2D?) {
        self.place = place
        self.userLocation = userLocation
        calculateDistance()
    }

    private func calculateDistance() {
        guard
            let lat = place.latitude,
            let lon = place.longitude,
            let userLoc = userLocation
        else {
            distanceInMeters = nil
            return
        }

        let placeLocation = CLLocation(latitude: lat, longitude: lon)
        let userCLLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        distanceInMeters = userCLLocation.distance(from: placeLocation)
    }

    var distanceFormatted: String {
        guard let distance = distanceInMeters else { return "Distancia desconocida" }
        if distance >= 1000 {
            return String(format: "%.2f km", distance / 1000)
        } else {
            return String(format: "%.0f m", distance)
        }
    }

    var googleMapsURL: URL? {
        guard let lat = place.latitude, let lon = place.longitude else { return nil }
        let urlString = "https://www.google.com/maps/dir/?api=1&destination=\(lat),\(lon)&travelmode=walking"
        return URL(string: urlString)
    }
}
