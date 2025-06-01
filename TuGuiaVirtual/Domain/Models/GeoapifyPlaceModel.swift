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
}

struct GeoapifyPlace: Codable, Identifiable {
    var id: String { placeId }
    
    let placeId: String
    let name: String?
    let street: String?
    let city: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case street
        case city
        case country
    }
}
