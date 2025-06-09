//
//  GeoapifyPlacesService.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 25/5/25.
//

import Foundation
import CoreLocation

class GeoapifyPlacesService {
    
    private let apiKey = "dcfdc050234d4497a8325ea8c2ebb7ab"
    
    func fetchNearbyPlaces(location: CLLocationCoordinate2D,
                           radius: Int = 1500,
                           category: String = "tourism",
                           completion: @escaping ([GeoapifyPlace]) -> Void) {
        
        let urlString = """
        https://api.geoapify.com/v2/places?categories=\(category)&filter=circle:\(location.longitude),\(location.latitude),\(radius)&limit=20&apiKey=\(apiKey)
        """
        
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error de red: \(error?.localizedDescription ?? "desconocido")")
                completion([])
                return
            }
            
            print(String(data: data, encoding: .utf8) ?? "Datos no legibles")

            
            do {
                let decoded = try JSONDecoder().decode(GeoapifyPlaceModel.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.features.map { $0.properties })
                }
            } catch {
                print("Error de parseo: \(error)")
                completion([])
            }
        }.resume()
    }
}
