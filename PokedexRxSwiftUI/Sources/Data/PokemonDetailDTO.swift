import Foundation

struct PokemonDetailDTO: Decodable {
    let abilities: [PokemonAbilityDTO]
    let baseExperience: Int?
    let forms: [NamedResourceDTO]
    let gameIndices: [GameIndexDTO]
    let height: Int
    let heldItems: [HeldItemDTO]
    let id: Int
    let isDefault: Bool
    let locationAreaEncounters: String
    let moves: [PokemonMoveDTO]
    let name: String
    let order: Int
    let species: NamedResourceDTO
    let sprites: PokemonSpritesDTO
    let stats: [PokemonStatDTO]
    let types: [PokemonTypeDTO]
    let weight: Int

    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case forms
        case gameIndices = "game_indices"
        case height
        case heldItems = "held_items"
        case id
        case isDefault = "is_default"
        case locationAreaEncounters = "location_area_encounters"
        case moves
        case name
        case order
        case species
        case sprites
        case stats
        case types
        case weight
    }
}

struct NamedResourceDTO: Decodable {
    let name: String
    let url: String
}

struct PokemonAbilityDTO: Decodable {
    let isHidden: Bool
    let slot: Int
    let ability: NamedResourceDTO

    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot
        case ability
    }
}

struct GameIndexDTO: Decodable {
    let gameIndex: Int
    let version: NamedResourceDTO

    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}

struct HeldItemDTO: Decodable {
    let item: NamedResourceDTO
    let versionDetails: [HeldItemVersionDTO]

    enum CodingKeys: String, CodingKey {
        case item
        case versionDetails = "version_details"
    }
}

struct HeldItemVersionDTO: Decodable {
    let rarity: Int
    let version: NamedResourceDTO
}

struct PokemonMoveDTO: Decodable {
    let move: NamedResourceDTO
    let versionGroupDetails: [MoveVersionDetailDTO]

    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

struct MoveVersionDetailDTO: Decodable {
    let levelLearnedAt: Int
    let moveLearnMethod: NamedResourceDTO
    let versionGroup: NamedResourceDTO

    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}

struct PokemonStatDTO: Decodable {
    let baseStat: Int
    let effort: Int
    let stat: NamedResourceDTO

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

struct PokemonTypeDTO: Decodable {
    let slot: Int
    let type: NamedResourceDTO
}

struct PokemonSpritesDTO: Decodable {
    let frontDefault: String?
    let frontShiny: String?
    let backDefault: String?
    let backShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
    }
}
