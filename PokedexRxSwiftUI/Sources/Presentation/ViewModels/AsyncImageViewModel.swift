import UIKit
import RxSwift

@MainActor
final class AsyncImageViewModel: ObservableObject {
    // Bridges RxSwift image loading into SwiftUI state.
    @Published private(set) var image: UIImage? = nil
    @Published private(set) var isLoading: Bool = false

    private let imageLoader: ImageLoader
    private let url: URL
    private let disposeBag = DisposeBag()

    init(imageLoader: ImageLoader, url: URL) {
        self.imageLoader = imageLoader
        self.url = url
    }

    // Starts the request once and keeps the result in memory.
    func load() {
        guard image == nil else { return }
        isLoading = true

        imageLoader.loadImage(url: url)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] image in
                guard let self else { return }
                self.isLoading = false
                self.image = image
            }, onFailure: { [weak self] _ in
                guard let self else { return }
                self.isLoading = false
            })
            .disposed(by: disposeBag)
    }
}
