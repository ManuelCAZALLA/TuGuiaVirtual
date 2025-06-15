
import SwiftUI
import CoreLocation

struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(viewModel: mockViewModel)
    }
    
    static var mockViewModel: PlaceDetailViewModel {
        let mockPlace = GeoapifyFeature(
            properties: GeoapifyPlace(
                placeId: "mock1",
                name: "Bar de Ejemplo",
                street: "Calle Inventada 45",
                city: "Barcelona",
                country: "España"
            ),
            geometry: Geometry(coordinates: [2.1734, 41.3851]) // Coordenadas de Barcelona
        )
        
        let userLocation = CLLocationCoordinate2D(latitude: 41.3888, longitude: 2.159) // Aproximación en Barcelona
        
        return PlaceDetailViewModel(place: mockPlace, userLocation: userLocation)
    }
}

#Preview { PlaceDetailView_Previews() }

