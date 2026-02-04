import UIKit
import RxSwift

final class DefaultImageLoader: ImageLoader {
    // Uses a Swift Concurrency actor for cache safety.
    private let networkClient: NetworkClient
    private let cache: ImageCacheActor

    init(networkClient: NetworkClient, cache: ImageCacheActor) {
        self.networkClient = networkClient
        self.cache = cache
    }

    // Loads images asynchronously with cache-first behavior.
    func loadImage(url: URL) -> Single<UIImage> {
        Single.create { [networkClient, cache] single in
            let sendBox = SingleEventBox(single)
            let disposableBox = SerialDisposableBox()
            let clientBox = NetworkClientBox(networkClient)
            let cacheBox = ImageCacheBox(cache)

            let task = Task {
                if let cached = await cacheBox.cache.image(for: url) {
                    sendBox.send(.success(cached))
                    return
                }

                let subscription = clientBox.client.get(url: url)
                    .subscribe(onSuccess: { data in
                        guard let image = UIImage(data: data) else {
                            sendBox.send(.failure(PokemonError.decoding))
                            return
                        }
                        Task { await cacheBox.cache.insert(image, for: url) }
                        sendBox.send(.success(image))
                    }, onFailure: { _ in
                        sendBox.send(.failure(PokemonError.network))
                    })

                disposableBox.serial.disposable = subscription
            }

            return Disposables.create {
                task.cancel()
                disposableBox.serial.dispose()
            }
        }
    }
}

// Sendable box for bridging RxSwift callbacks into Task closures in Swift 6.
private final class SingleEventBox: @unchecked Sendable {
    private let sender: (SingleEvent<UIImage>) -> Void

    init(_ sender: @escaping (SingleEvent<UIImage>) -> Void) {
        self.sender = sender
    }

    func send(_ event: SingleEvent<UIImage>) {
        sender(event)
    }
}

// Sendable box for SerialDisposable used across Task boundaries.
private final class SerialDisposableBox: @unchecked Sendable {
    let serial = SerialDisposable()
}

// Sendable boxes for dependency references used inside Task closures.
private final class NetworkClientBox: @unchecked Sendable {
    let client: NetworkClient

    init(_ client: NetworkClient) {
        self.client = client
    }
}

private final class ImageCacheBox: @unchecked Sendable {
    let cache: ImageCacheActor

    init(_ cache: ImageCacheActor) {
        self.cache = cache
    }
}
