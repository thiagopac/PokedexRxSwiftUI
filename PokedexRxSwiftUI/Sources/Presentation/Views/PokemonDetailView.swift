import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject private var viewModel: PokemonDetailViewModel

    init(viewModel: PokemonDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            if viewModel.isLoading {
                LoadingView(title: "Loading Details")
            } else if let message = viewModel.errorMessage {
                ErrorView(message: message, action: viewModel.retry)
                    .padding(.horizontal)
            } else if let detail = viewModel.detail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        heroSection(detail)
                        basicInfoSection(detail)
                        typesSection(detail.types)
                        statsSection(detail.stats)
                        abilitiesSection(detail.abilities)
                        spritesSection(detail)
                        encountersSection(viewModel)
                        formsSection(detail.forms)
                        gameIndicesSection(detail.gameIndices)
                        heldItemsSection(detail.heldItems)
                        movesSection(detail.moves)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle("Details")
        .onAppear { viewModel.load() }
    }

    private func heroSection(_ detail: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                AsyncImageView(imageLoader: container.imageLoader, url: detail.imageURL)
                    .frame(width: 120, height: 120)

                VStack(alignment: .leading, spacing: 6) {
                    Text(detail.name.capitalizedFirstLetter)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.appPrimaryText)

                    Text("#\(detail.id)")
                        .font(.headline)
                        .foregroundColor(Color.appSecondaryText)

                    HStack(spacing: 8) {
                        ForEach(detail.types, id: \.type.name) { type in
                            Text(type.type.name.capitalizedFirstLetter)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.appSecondaryBackground)
                                .cornerRadius(12)
                        }
                    }
                }
            }

            HStack(spacing: 16) {
                StatChip(title: "Height", value: "\(detail.height)")
                StatChip(title: "Weight", value: "\(detail.weight)")
                StatChip(title: "Base XP", value: detail.baseExperience.map(String.init) ?? "-")
            }
        }
        .padding(16)
        .background(LinearGradient(gradient: Gradient(colors: [Color.appSecondaryBackground, Color.appBackground]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(16)
    }

    private func basicInfoSection(_ detail: PokemonDetail) -> some View {
        SectionCard(title: "Basic Info") {
            KeyValueRow(label: "Height", value: "\(detail.height)")
            KeyValueRow(label: "Weight", value: "\(detail.weight)")
            KeyValueRow(label: "Order", value: "\(detail.order)")
            KeyValueRow(label: "Default", value: detail.isDefault ? "Yes" : "No")
            KeyValueRow(label: "Base Experience", value: detail.baseExperience.map(String.init) ?? "-" )
            KeyValueRow(label: "Location Encounters", value: detail.locationAreaEncounters)
            KeyValueRow(label: "Species", value: detail.species.name.capitalizedFirstLetter)
        }
    }

    private func typesSection(_ types: [PokemonType]) -> some View {
        SectionCard(title: "Types") {
            WrapLayout(items: types.map { $0.type.name.capitalizedFirstLetter })
        }
    }

    private func statsSection(_ stats: [PokemonStat]) -> some View {
        SectionCard(title: "Stats") {
            ForEach(stats, id: \.stat.name) { stat in
                StatBarRow(label: stat.stat.name.capitalizedFirstLetter, value: stat.baseStat, maxValue: 200)
            }
        }
    }

    private func abilitiesSection(_ abilities: [PokemonAbility]) -> some View {
        SectionCard(title: "Abilities") {
            ForEach(abilities, id: \.ability.name) { ability in
                let hidden = ability.isHidden ? "Hidden" : "Normal"
                KeyValueRow(label: ability.ability.name.capitalizedFirstLetter, value: "Slot \(ability.slot) • \(hidden)")
            }
        }
    }

    private func spritesSection(_ detail: PokemonDetail) -> some View {
        SectionCard(title: "Sprites") {
            SpriteRow(title: "Front Default", urlString: detail.sprites.frontDefault)
            SpriteRow(title: "Front Shiny", urlString: detail.sprites.frontShiny)
            SpriteRow(title: "Back Default", urlString: detail.sprites.backDefault)
            SpriteRow(title: "Back Shiny", urlString: detail.sprites.backShiny)
        }
    }

    private func encountersSection(_ viewModel: PokemonDetailViewModel) -> some View {
        SectionCard(title: "Location Encounters") {
            if viewModel.isLoadingEncounters {
                ProgressView()
            } else if viewModel.encounters.isEmpty {
                Text("No known encounters.")
                    .foregroundColor(Color.appSecondaryText)
            } else {
                ForEach(viewModel.encounters, id: \.locationArea.name) { encounter in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(encounter.locationArea.name.capitalizedFirstLetter)
                            .font(.headline)
                            .foregroundColor(Color.appPrimaryText)

                        ForEach(encounter.versionDetails, id: \.version.name) { version in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(version.version.name.capitalizedFirstLetter)
                                    .font(.subheadline)
                                    .foregroundColor(Color.appSecondaryText)

                                Text("Max Chance: \(version.maxChance)%")
                                    .font(.caption)
                                    .foregroundColor(Color.appSecondaryText)

                                ForEach(version.encounterDetails, id: \.method.name) { detail in
                                    Text("Level \(detail.minLevel)-\(detail.maxLevel) • \(detail.method.name.capitalizedFirstLetter) • \(detail.chance)%")
                                        .font(.caption)
                                        .foregroundColor(Color.appPrimaryText)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
    }

    private func formsSection(_ forms: [NamedResource]) -> some View {
        SectionCard(title: "Forms") {
            ForEach(forms, id: \.name) { form in
                KeyValueRow(label: form.name.capitalizedFirstLetter, value: form.url)
            }
        }
    }

    private func gameIndicesSection(_ indices: [GameIndex]) -> some View {
        SectionCard(title: "Game Indices") {
            ForEach(indices, id: \.version.name) { index in
                KeyValueRow(label: index.version.name.capitalizedFirstLetter, value: "\(index.gameIndex)")
            }
        }
    }

    private func heldItemsSection(_ items: [HeldItem]) -> some View {
        SectionCard(title: "Held Items") {
            if items.isEmpty {
                Text("None")
                    .foregroundColor(Color.appSecondaryText)
            } else {
                ForEach(items, id: \.item.name) { item in
                    Text(item.item.name.capitalizedFirstLetter)
                        .foregroundColor(Color.appPrimaryText)
                }
            }
        }
    }

    private func movesSection(_ moves: [PokemonMove]) -> some View {
        SectionCard(title: "Moves (\(moves.count))") {
            DisclosureGroup("Show Moves") {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(moves, id: \.move.name) { move in
                        Text(move.move.name.capitalizedFirstLetter)
                            .foregroundColor(Color.appPrimaryText)
                    }
                }
                .padding(.top, 8)
            }
        }
    }

}

private struct SectionCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color.appPrimaryText)
            content
        }
        .padding(12)
        .background(Color.appSecondaryBackground)
        .cornerRadius(12)
    }
}

private struct KeyValueRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(Color.appSecondaryText)
            Text(value)
                .font(.body)
                .foregroundColor(Color.appPrimaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct StatChip: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color.appSecondaryText)
            Text(value)
                .font(.headline)
                .foregroundColor(Color.appPrimaryText)
        }
        .padding(10)
        .background(Color.appSecondaryBackground)
        .cornerRadius(12)
    }
}

private struct StatBarRow: View {
    let label: String
    let value: Int
    let maxValue: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .foregroundColor(Color.appPrimaryText)
                Spacer()
                Text("\(value)")
                    .foregroundColor(Color.appSecondaryText)
            }
            GeometryReader { proxy in
                let width = proxy.size.width
                let ratio = min(Double(value) / Double(maxValue), 1.0)
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.appBackground)
                        .frame(height: 8)
                    Capsule()
                        .fill(Color.appPrimaryText.opacity(0.7))
                        .frame(width: width * ratio, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

private struct WrapLayout: View {
    let items: [String]

    var body: some View {
        FlexibleView(data: items, spacing: 8, alignment: .leading) { item in
            Text(item)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.appBackground)
                .cornerRadius(10)
                .foregroundColor(Color.appPrimaryText)
        }
    }
}

private struct SpriteRow: View {
    @EnvironmentObject private var container: AppContainer
    let title: String
    let urlString: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color.appSecondaryText)

            if let urlString, let url = URL(string: urlString) {
                AsyncImageView(imageLoader: container.imageLoader, url: url)
                    .frame(height: 120)
            } else {
                Text("Not Available")
                    .foregroundColor(Color.appSecondaryText)
            }
        }
    }
}

private struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    init(data: Data, spacing: CGFloat, alignment: HorizontalAlignment, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            generateContent(in: geometry)
        }
        .frame(minHeight: 24)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
            ForEach(Array(data), id: \.self) { item in
                content(item)
                    .alignmentGuide(.leading) { dimension in
                        if width + dimension.width > geometry.size.width {
                            width = 0
                            height -= dimension.height + spacing
                        }
                        let result = width
                        width += dimension.width + spacing
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        return result
                    }
            }
        }
    }
}
