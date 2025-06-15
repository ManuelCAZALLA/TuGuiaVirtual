//
//  CoreLocationManager.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 25/5/25.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var permissionDenied = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        checkAuthorizationStatus()
    }

    func requestLocation() {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .restricted, .denied:
            permissionDenied = true
        @unknown default:
            permissionDenied = true
        }
    }

    private func checkAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        if status == .denied || status == .restricted {
            permissionDenied = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error de ubicación: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
}
