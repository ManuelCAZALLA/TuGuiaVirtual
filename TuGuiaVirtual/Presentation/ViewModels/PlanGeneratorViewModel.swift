import Foundation
import CoreLocation

class PlanGeneratorViewModel: ObservableObject {
    @Published var selectedDuration: PlanDuration = .twoHours
    @Published var selectedCategories: Set<PlaceCategory> = []
    @Published var generatedPlan: Plan?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var cityInput: String = ""
    @Published var useCurrentLocation: Bool = true
    
    private let locationManager = LocationManager()
    private let placesService = GeoapifyPlacesService()
    
    func generatePlan() {
        isLoading = true
        errorMessage = nil
        
        if useCurrentLocation {
            generatePlanWithCurrentLocation()
        } else {
            generatePlanWithCity()
        }
    }
    
    private func generatePlanWithCurrentLocation() {
        guard let userLocation = locationManager.userLocation else {
            errorMessage = "No se pudo obtener tu ubicación actual"
            isLoading = false
            return
        }
        
        generatePlanWithLocation(userLocation)
    }
    
    private func generatePlanWithCity() {
        guard !cityInput.isEmpty else {
            errorMessage = "Por favor, introduce una ciudad"
            isLoading = false
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityInput) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let coordinate = placemarks?.first?.location?.coordinate {
                    self.generatePlanWithLocation(coordinate)
                } else {
                    self.isLoading = false
                    self.errorMessage = "No se pudo encontrar la ciudad '\(self.cityInput)'"
                }
            }
        }
    }
    
    private func generatePlanWithLocation(_ location: CLLocationCoordinate2D) {
        // Calcular cuántas actividades podemos incluir basado en la duración
        let activitiesCount = calculateActivitiesCount(for: selectedDuration)
        
        // Obtener lugares para cada categoría seleccionada
        let group = DispatchGroup()
        var allPlaces: [GeoapifyPlace] = []
        
        for category in selectedCategories {
            group.enter()
            placesService.fetchNearbyPlaces(location: location, category: category.rawValue) { places in
                allPlaces.append(contentsOf: places)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.createPlan(from: allPlaces, userLocation: location, activitiesCount: activitiesCount)
            self.isLoading = false
        }
    }
    
    private func calculateActivitiesCount(for duration: PlanDuration) -> Int {
        switch duration {
        case .twoHours: return 2
        case .fourHours: return 3
        case .sixHours: return 4
        case .fullDay: return 6
        }
    }
    
    private func createPlan(from places: [GeoapifyPlace], userLocation: CLLocationCoordinate2D, activitiesCount: Int) {
        // Ordenar lugares por distancia
        let sortedPlaces = places.sorted { place1, place2 in
            let distance1 = calculateDistance(from: userLocation, to: place1)
            let distance2 = calculateDistance(from: userLocation, to: place2)
            return distance1 < distance2
        }
        
        // Seleccionar los lugares más cercanos
        let selectedPlaces = Array(sortedPlaces.prefix(activitiesCount))
        
        // Crear actividades
        var activities: [PlanActivity] = []
        var totalDistance: Double = 0
        var lastLocation = userLocation
        
        for (index, place) in selectedPlaces.enumerated() {
            let distance = calculateDistance(from: lastLocation, to: place)
            totalDistance += distance
            lastLocation = CLLocationCoordinate2D(
                latitude: place.latitude ?? 0,
                longitude: place.longitude ?? 0
            )
            
            let activity = PlanActivity(
                place: place,
                category: selectedCategories.first ?? .bar,
                estimatedDuration: selectedDuration.rawValue / Double(activitiesCount),
                order: index + 1
            )
            activities.append(activity)
        }
        
        // Crear el plan
        generatedPlan = Plan(
            name: "Plan de \(selectedDuration.displayName) en \(useCurrentLocation ? "tu ubicación" : cityInput)",
            duration: selectedDuration.rawValue,
            activities: activities,
            totalDistance: totalDistance,
            estimatedCost: Double(activitiesCount) * 15.0 // Estimación aproximada
        )
    }
    
    private func calculateDistance(from: CLLocationCoordinate2D, to: GeoapifyPlace) -> Double {
        guard let lat = to.latitude, let lon = to.longitude else { return Double.infinity }
        
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: lat, longitude: lon)
        
        return fromLocation.distance(from: toLocation)
    }
} 