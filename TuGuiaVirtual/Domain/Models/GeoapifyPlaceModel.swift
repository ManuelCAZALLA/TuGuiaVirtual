//
//  GeoapifyPlaceModel.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 25/5/25.
//

struct GeoapifyPlaceModel: Codable {
    let features: [GeoapifyFeature]
}

struct GeoapifyFeature: Codable {
    let properties: GeoapifyPlace
    let geometry: Geometry
}

struct Geometry: Codable {
    let coordinates: [Double] 
}

struct GeoapifyPlace: Codable, Identifiable {
    var id: String { placeId }
    
    let placeId: String
    let name: String?
    let street: String?
    let city: String?
    let country: String?
    var latitude: Double?
    var longitude: Double?

    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case street
        case city
        case country
    }
}

extension GeoapifyFeature {
    var latitude: Double? {
        guard geometry.coordinates.count == 2 else { return nil }
        return geometry.coordinates[1]
    }
    
    var longitude: Double? {
        guard geometry.coordinates.count == 2 else { return nil }
        return geometry.coordinates[0]
    }
}
