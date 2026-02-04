import Foundation
import RxSwift

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(url: URL) -> Single<Data> {
        Single.create { [session] single in
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    single(.failure(PokemonError.network))
                    return
                }
                guard let data else {
                    single(.failure(PokemonError.network))
                    return
                }
                single(.success(data))
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
