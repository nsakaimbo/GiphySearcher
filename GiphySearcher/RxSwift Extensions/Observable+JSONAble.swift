import Foundation
import Moya
import RxSwift
import SwiftyJSON

// Reference: https://github.com/artsy/eidolon/blob/master/Kiosk/Observable%2BJSONAble.swift

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
            
            guard var dicts = array as? [Dictionary] else {
                throw JSONError.CouldNotParse
            }
          
            // filter for PG-13 and "R" ratings
            dicts = dicts.filter({ !($0["rating"] as! String == "pg-13")})
            dicts = dicts.filter({ !($0["rating"] as! String == "r")})
            
            return dicts.map { B.fromJSON($0) }
        }
    }
}