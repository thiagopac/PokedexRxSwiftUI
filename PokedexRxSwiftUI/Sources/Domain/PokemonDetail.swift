import Foundation

struct PokemonDetail: Identifiable, Equatable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int?
    let order: Int
    let isDefault: Bool
    let locationAreaEncounters: String
    let species: NamedResource
    let sprites: PokemonSprites
    let abilities: [PokemonAbility]
    let forms: [NamedResource]
    let gameIndices: [GameIndex]
    let heldItems: [HeldItem]
    let moves: [PokemonMove]
    let stats: [PokemonStat]
    let types: [PokemonType]
}

struct NamedResource: Equatable {
    let name: String
    let url: String
}

struct PokemonAbility: Equatable {
    let isHidden: Bool
    let slot: Int
    let ability: NamedResource
}

struct GameIndex: Equatable {
    let gameIndex: Int
    let version: NamedResource
}

struct HeldItem: Equatable {
    let item: NamedResource
    let versionDetails: [HeldItemVersion]
}

struct HeldItemVersion: Equatable {
    let rarity: Int
    let version: NamedResource
}

struct PokemonMove: Equatable {
    let move: NamedResource
    let versionGroupDetails: [MoveVersionDetail]
}

struct MoveVersionDetail: Equatable {
    let levelLearnedAt: Int
    let moveLearnMethod: NamedResource
    let versionGroup: NamedResource
}

struct PokemonStat: Equatable {
    let baseStat: Int
    let effort: Int
    let stat: NamedResource
}

struct PokemonType: Equatable {
    let slot: Int
    let type: NamedResource
}

struct PokemonSprites: Equatable {
    let frontDefault: String?
    let frontShiny: String?
    let backDefault: String?
    let backShiny: String?
}
