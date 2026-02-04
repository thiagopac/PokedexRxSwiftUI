import Foundation
import RxSwift

protocol NetworkClient {
    func get(url: URL) -> Single<Data>
}
