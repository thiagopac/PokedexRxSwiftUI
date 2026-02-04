import SwiftUI

struct AsyncImageView: View {
    @StateObject private var viewModel: AsyncImageViewModel

    init(imageLoader: ImageLoader, url: URL) {
        _viewModel = StateObject(wrappedValue: AsyncImageViewModel(imageLoader: imageLoader, url: url))
    }

    // Simple async image view with loading and placeholder states.
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appSecondaryBackground)

            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding(8)
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .foregroundColor(Color.appSecondaryText)
            }
        }
        .frame(height: 120)
        .onAppear { viewModel.load() }
    }
}
