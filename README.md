# PokedexRxSwiftUI

A small but complete Pokedex app built for study and re‑learning modern Swift.
It fetches the first 151 Pokemon from PokeAPI, supports pagination and search,
and shows a detailed Pokemon screen with stats, sprites, and real location encounters.

## What this project includes

- SwiftUI app targeting iOS 15+
- Swift 6 language settings
- Clean separation of layers (App, Data, Domain, Presentation)
- Dependency injection via an `AppContainer`
- RxSwift for networking and async flows
- Actor‑based image cache + async image loading
- Pagination (client‑side) and search
- Adaptive layout for iPhone and iPad (orientation friendly)
- Dark mode ready colors
- Unit tests and UI tests

## Main features

- **Pokemon list** with search and pagination (first 151 only)
- **Pokemon detail** with:
  - Basic info (height, weight, base XP, order, default)
  - Types and stats
  - Abilities, forms, game indices, moves, held items
  - Sprite variants (front/back, default/shiny)
  - **Location Encounters** loaded from the API (real data, not just the URL)

## Architecture overview

```
PokedexRxSwiftUI
├─ App
│  ├─ PokedexRxSwiftUIApp
│  ├─ AppEnvironment
│  └─ AppContainer
├─ Data
│  ├─ NetworkClient / URLSessionNetworkClient
│  ├─ PokemonRepository + DTOs
│  ├─ ImageLoader + ImageCacheActor
│  └─ Mocks
├─ Domain
│  ├─ Pokemon
│  ├─ PokemonDetail
│  └─ LocationEncounter
├─ Presentation
│  ├─ ViewModels
│  └─ Views
└─ Utilities
   └─ Extensions
```

## Tech stack

- **Swift**: 6.0
- **iOS target**: 15.0+
- **UI**: SwiftUI
- **Reactive**: RxSwift + RxCocoa (Swift Package Manager)
- **Networking**: URLSession + RxSwift
- **Concurrency**: Actor for image cache

## API used

- **PokeAPI**
  - List: `https://pokeapi.co/api/v2/pokemon?limit=151&offset=0`
  - Detail: `https://pokeapi.co/api/v2/pokemon/{id}`
  - Encounters: URL returned by the detail response
- **Sprites**
  - `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/{id}.png`

## How to run

1. Open `PokedexRxSwiftUI.xcodeproj`
2. Resolve Swift Package Manager dependencies
3. Select a signing team in **Signing & Capabilities**
4. Run on an iPhone or iPad (device or simulator)

## Tests

- Unit tests are in `PokedexRxSwiftUI/Tests`
- UI tests are in `PokedexRxSwiftUI/UITests`

## Notes

- App icons are placeholders; feel free to add real assets.
- The project is intentionally verbose and commented for learning.

## License

Personal study project.
