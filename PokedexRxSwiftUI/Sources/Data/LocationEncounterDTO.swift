import Foundation

struct LocationEncounterDTO: Decodable {
    let locationArea: NamedResourceDTO
    let versionDetails: [LocationEncounterVersionDTO]

    enum CodingKeys: String, CodingKey {
        case locationArea = "location_area"
        case versionDetails = "version_details"
    }
}

struct LocationEncounterVersionDTO: Decodable {
    let version: NamedResourceDTO
    let maxChance: Int
    let encounterDetails: [EncounterDetailDTO]

    enum CodingKeys: String, CodingKey {
        case version
        case maxChance = "max_chance"
        case encounterDetails = "encounter_details"
    }
}

struct EncounterDetailDTO: Decodable {
    let minLevel: Int
    let maxLevel: Int
    let chance: Int
    let method: NamedResourceDTO
    let conditionValues: [NamedResourceDTO]

    enum CodingKeys: String, CodingKey {
        case minLevel = "min_level"
        case maxLevel = "max_level"
        case chance
        case method
        case conditionValues = "condition_values"
    }
}
