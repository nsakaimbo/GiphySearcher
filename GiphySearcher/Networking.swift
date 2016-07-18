import Foundation
import Moya

protocol NetworkingType {
    associatedtype T: TargetType
    var provider: RxMoyaProvider<T> { get }
}

struct Networking: NetworkingType {
    typealias T = GiphyAPI
    
    let provider: RxMoyaProvider<T>
    
    init(provider: RxMoyaProvider<T> = RxMoyaProvider<T>()) {
        self.provider = provider
    }
}