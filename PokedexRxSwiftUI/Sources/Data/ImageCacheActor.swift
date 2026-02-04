import UIKit

actor ImageCacheActor {
    private var cache: [URL: UIImage] = [:]

    func image(for url: URL) -> UIImage? {
        cache[url]
    }

    func insert(_ image: UIImage, for url: URL) {
        cache[url] = image
    }
}
