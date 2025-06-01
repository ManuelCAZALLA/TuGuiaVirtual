//
//  GeoapifyPlacesModel.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 25/5/25.
//

enum PlaceCategory: String, CaseIterable, Identifiable {
    case bar = "catering.bar"
    case restaurant = "catering.restaurant"
    case monument = "entertainment.monument"
    case museum = "entertainment.museum"
    case nightlife = "entertainment.nightclub"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bar: return "Bares"
        case .restaurant: return "Restaurantes"
        case .monument: return "Monumentos"
        case .museum: return "Museos"
        case .nightlife: return "Vida Nocturna"
        }
    }

    var emoji: String {
        switch self {
        case .bar: return "🍺"
        case .restaurant: return "🍽️"
        case .monument: return "🏛️"
        case .museum: return "🖼️"
        case .nightlife: return "💃"
        }
    }
}
