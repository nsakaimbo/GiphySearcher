import Foundation
import Moya
import RxSwift

enum JSONError: String {
    case CouldNotParse
    case MissingData
}

extension JSONError: ErrorType {}

extension Observable {
    
    typealias Dictionary = [String: AnyObject]
    
    /// Given JSONified data, pass back objects
    func mapToObject<B: JSONAbleType>(classType: B.Type) -> Observable<B> {
        return self.map { json in
            guard let dict = json as? Dictionary else {
                throw JSONError.CouldNotParse
            }
            return B.fromJSON(dict)
        }
    }
    
    /// Get given JSONified data, pass back objects as an array
    func mapToObjectArray<B: JSONAbleType>(classType: B.Type) -> Observable<[B]> {
        return self.map { json in
            guard let dict = json as? Dictionary,
                array = dict["data"] as? [AnyObject] else {
                    throw JSONError.CouldNotParse
            }
            
            guard let dicts = array as? [Dictionary] else {
                throw JSONError.CouldNotParse
            }
            
            return dicts.map { B.fromJSON($0) }
        }
    }
}