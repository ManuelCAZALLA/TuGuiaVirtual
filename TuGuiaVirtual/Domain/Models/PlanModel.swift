import Foundation

struct Plan: Identifiable {
    let id = UUID()
    let name: String
    let duration: TimeInterval
    let activities: [PlanActivity]
    let totalDistance: Double
    let estimatedCost: Double
}

struct PlanActivity: Identifiable {
    let id = UUID()
    let place: GeoapifyPlace
    let category: PlaceCategory
    let estimatedDuration: TimeInterval
    let order: Int
}

enum PlanDuration: TimeInterval, CaseIterable {
    case twoHours = 7200 // 2 horas en segundos
    case fourHours = 14400 // 4 horas en segundos
    case sixHours = 21600 // 6 horas en segundos
    case fullDay = 43200 // 12 horas en segundos
    
    var displayName: String {
        switch self {
        case .twoHours: return "2 horas"
        case .fourHours: return "4 horas"
        case .sixHours: return "6 horas"
        case .fullDay: return "Día completo"
        }
    }
} 