import UIKit
import RxSwift

final class MockPokemonRepository: PokemonRepository {
    func fetchAllPokemon() -> Single<[Pokemon]> {
        let items = (1...30).map { id in
            Pokemon(id: id, name: "pokemon-\(id)", imageURL: URL.pokemonSpriteURL(id: id)!)
        }
        return .just(items)
    }

    func fetchPokemonDetail(id: Int) -> Single<PokemonDetail> {
        let detail = PokemonDetail(
            id: id,
            name: "pokemon-\(id)",
            height: 7,
            weight: 69,
            baseExperience: 64,
            order: id,
            isDefault: true,
            locationAreaEncounters: "https://pokeapi.co/api/v2/pokemon/\(id)/encounters",
            species: NamedResource(name: "species-\(id)", url: "https://pokeapi.co/api/v2/pokemon-species/\(id)/"),
            sprites: PokemonSprites(frontDefault: nil, frontShiny: nil, backDefault: nil, backShiny: nil),
            abilities: [PokemonAbility(isHidden: false, slot: 1, ability: NamedResource(name: "ability-\(id)", url: ""))],
            forms: [NamedResource(name: "form-\(id)", url: "")],
            gameIndices: [GameIndex(gameIndex: 1, version: NamedResource(name: "red", url: ""))],
            heldItems: [],
            moves: [],
            stats: [
                PokemonStat(baseStat: 35, effort: 0, stat: NamedResource(name: "hp", url: "")),
                PokemonStat(baseStat: 55, effort: 0, stat: NamedResource(name: "attack", url: ""))
            ],
            types: [PokemonType(slot: 1, type: NamedResource(name: "grass", url: ""))]
        )
        return .just(detail)
    }

    func fetchLocationEncounters(urlString: String) -> Single<[LocationEncounter]> {
        let encounter = LocationEncounter(
            locationArea: NamedResource(name: "viridian-forest", url: ""),
            versionDetails: [
                LocationEncounterVersion(
                    version: NamedResource(name: "red", url: ""),
                    maxChance: 35,
                    encounterDetails: [
                        EncounterDetail(minLevel: 3, maxLevel: 5, chance: 25, method: NamedResource(name: "walk", url: ""), conditions: [])
                    ]
                )
            ]
        )
        return .just([encounter])
    }
}

final class MockImageLoader: ImageLoader {
    func loadImage(url: URL) -> Single<UIImage> {
        let size = CGSize(width: 64, height: 64)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIColor.systemTeal.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return .just(image)
    }
}
