import Foundation

enum PokeAPIEndpoint {
    static let baseURL = URL(string: "https://pokeapi.co/api/v2")

    case pokemonList(limit: Int, offset: Int)
    case pokemonDetail(id: Int)

    var url: URL? {
        guard let baseURL = Self.baseURL else { return nil }
        switch self {
        case let .pokemonList(limit, offset):
            var components = URLComponents(url: baseURL.appendingPathComponent("pokemon"), resolvingAgainstBaseURL: false)
            components?.queryItems = [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
            return components?.url
        case let .pokemonDetail(id):
            return baseURL.appendingPathComponent("pokemon").appendingPathComponent(String(id))
        }
    }
}
