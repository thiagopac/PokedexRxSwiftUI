import Foundation
import RxSwift

protocol PokemonRepository {
    func fetchAllPokemon() -> Single<[Pokemon]>
    func fetchPokemonDetail(id: Int) -> Single<PokemonDetail>
    func fetchLocationEncounters(urlString: String) -> Single<[LocationEncounter]>
}

final class DefaultPokemonRepository: PokemonRepository {
    // PokeAPI repository using RxSwift and JSON decoding.
    private let networkClient: NetworkClient
    private let decoder: JSONDecoder

    init(networkClient: NetworkClient, decoder: JSONDecoder = JSONDecoder()) {
        self.networkClient = networkClient
        self.decoder = decoder
    }

    // Fetches the first 151 Pokemon and maps DTOs to domain models.
    func fetchAllPokemon() -> Single<[Pokemon]> {
        guard let url = PokeAPIEndpoint.pokemonList(limit: 151, offset: 0).url else {
            return .error(PokemonError.invalidURL)
        }

        return networkClient.get(url: url)
            .map { [decoder] data in
                do {
                    let dto = try decoder.decode(PokemonListDTO.self, from: data)
                    return dto.results
                        .compactMap { entry in
                            guard let id = entry.url.pokemonId else { return nil }
                            guard let imageURL = URL.pokemonSpriteURL(id: id) else { return nil }
                            return Pokemon(id: id, name: entry.name, imageURL: imageURL)
                        }
                        .sorted { $0.id < $1.id }
                } catch {
                    throw PokemonError.decoding
                }
            }
    }

    // Fetches a single Pokemon detail and maps the full response.
    func fetchPokemonDetail(id: Int) -> Single<PokemonDetail> {
        guard let url = PokeAPIEndpoint.pokemonDetail(id: id).url else {
            return .error(PokemonError.invalidURL)
        }

        return networkClient.get(url: url)
            .map { [decoder] data in
                do {
                    let dto = try decoder.decode(PokemonDetailDTO.self, from: data)
                    return PokemonDetailMapper.map(dto: dto)
                } catch {
                    throw PokemonError.decoding
                }
            }
    }

    // Fetches location encounters using the URL provided by the detail response.
    func fetchLocationEncounters(urlString: String) -> Single<[LocationEncounter]> {
        guard let url = URL(string: urlString) else {
            return .error(PokemonError.invalidURL)
        }

        return networkClient.get(url: url)
            .map { [decoder] data in
                do {
                    let dto = try decoder.decode([LocationEncounterDTO].self, from: data)
                    return dto.map(PokemonDetailMapper.map)
                } catch {
                    throw PokemonError.decoding
                }
            }
    }
}

enum PokemonDetailMapper {
    static func map(dto: PokemonDetailDTO) -> PokemonDetail {
        PokemonDetail(
            id: dto.id,
            name: dto.name,
            height: dto.height,
            weight: dto.weight,
            baseExperience: dto.baseExperience,
            order: dto.order,
            isDefault: dto.isDefault,
            locationAreaEncounters: dto.locationAreaEncounters,
            species: map(dto.species),
            sprites: map(dto.sprites),
            abilities: dto.abilities.map(map),
            forms: dto.forms.map(map),
            gameIndices: dto.gameIndices.map(map),
            heldItems: dto.heldItems.map(map),
            moves: dto.moves.map(map),
            stats: dto.stats.map(map),
            types: dto.types.map(map)
        )
    }

    private static func map(_ dto: NamedResourceDTO) -> NamedResource {
        NamedResource(name: dto.name, url: dto.url)
    }

    private static func map(_ dto: PokemonSpritesDTO) -> PokemonSprites {
        PokemonSprites(
            frontDefault: dto.frontDefault,
            frontShiny: dto.frontShiny,
            backDefault: dto.backDefault,
            backShiny: dto.backShiny
        )
    }

    private static func map(_ dto: PokemonAbilityDTO) -> PokemonAbility {
        PokemonAbility(isHidden: dto.isHidden, slot: dto.slot, ability: map(dto.ability))
    }

    private static func map(_ dto: GameIndexDTO) -> GameIndex {
        GameIndex(gameIndex: dto.gameIndex, version: map(dto.version))
    }

    private static func map(_ dto: HeldItemDTO) -> HeldItem {
        HeldItem(item: map(dto.item), versionDetails: dto.versionDetails.map(map))
    }

    private static func map(_ dto: HeldItemVersionDTO) -> HeldItemVersion {
        HeldItemVersion(rarity: dto.rarity, version: map(dto.version))
    }

    private static func map(_ dto: PokemonMoveDTO) -> PokemonMove {
        PokemonMove(move: map(dto.move), versionGroupDetails: dto.versionGroupDetails.map(map))
    }

    private static func map(_ dto: MoveVersionDetailDTO) -> MoveVersionDetail {
        MoveVersionDetail(
            levelLearnedAt: dto.levelLearnedAt,
            moveLearnMethod: map(dto.moveLearnMethod),
            versionGroup: map(dto.versionGroup)
        )
    }

    private static func map(_ dto: PokemonStatDTO) -> PokemonStat {
        PokemonStat(baseStat: dto.baseStat, effort: dto.effort, stat: map(dto.stat))
    }

    private static func map(_ dto: PokemonTypeDTO) -> PokemonType {
        PokemonType(slot: dto.slot, type: map(dto.type))
    }

    static func map(_ dto: LocationEncounterDTO) -> LocationEncounter {
        LocationEncounter(
            locationArea: map(dto.locationArea),
            versionDetails: dto.versionDetails.map(map)
        )
    }

    private static func map(_ dto: LocationEncounterVersionDTO) -> LocationEncounterVersion {
        LocationEncounterVersion(
            version: map(dto.version),
            maxChance: dto.maxChance,
            encounterDetails: dto.encounterDetails.map(map)
        )
    }

    private static func map(_ dto: EncounterDetailDTO) -> EncounterDetail {
        EncounterDetail(
            minLevel: dto.minLevel,
            maxLevel: dto.maxLevel,
            chance: dto.chance,
            method: map(dto.method),
            conditions: dto.conditionValues.map(map)
        )
    }
}
