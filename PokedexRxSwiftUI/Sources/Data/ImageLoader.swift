import UIKit
import RxSwift

protocol ImageLoader {
    func loadImage(url: URL) -> Single<UIImage>
}
