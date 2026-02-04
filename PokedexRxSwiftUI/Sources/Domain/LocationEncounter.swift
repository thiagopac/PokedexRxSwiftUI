import Foundation

struct LocationEncounter: Equatable {
    let locationArea: NamedResource
    let versionDetails: [LocationEncounterVersion]
}

struct LocationEncounterVersion: Equatable {
    let version: NamedResource
    let maxChance: Int
    let encounterDetails: [EncounterDetail]
}

struct EncounterDetail: Equatable {
    let minLevel: Int
    let maxLevel: Int
    let chance: Int
    let method: NamedResource
    let conditions: [NamedResource]
}
