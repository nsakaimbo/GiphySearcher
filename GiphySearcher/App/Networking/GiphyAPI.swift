import Foundation
import Moya

// In production, we would use a more secure way of storing and retrieving our API keys.
// However, we are using Giphy's public API key and hard-coding is acceptable for example purposes.
private let API_KEY = "dc6zaTOxFJmzC"

enum GiphyAPI {
    case Search(query: String)
    case Trending
}

extension GiphyAPI: TargetType {
    
    var baseURL: NSURL { return NSURL(string: "https://api.giphy.com/v1/gifs")! }
    
    var path: String {
        switch self {
        case .Search:
            return "/search"
        case .Trending:
            return "/trending"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Search, .Trending:
            return .GET
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .Search (let query):
            return ["q": query.PlusEncodedString, "api_key": API_KEY]
        case .Trending:
            return ["api_key": API_KEY]
        }
    }
    
    var sampleData: NSData {
        switch self {
        case .Search:
            return stubbedResponse("Search")
        case .Trending:
            return stubbedResponse("Trending")
        }
    }
    
//    var multipartBody: [MultipartFormData]? {
//        return nil
//    }
   
    // Helper for stubbed responses
    private func stubbedResponse(filename: String) -> NSData! {
        class TestClass: NSObject {}
        
        let bundle = NSBundle(forClass: TestClass.self)
        let path = bundle.pathForResource(filename, ofType: "json")
        return NSData(contentsOfFile: path!)
    }
}

private extension String {
    
    var PlusEncodedString: String {
        return self
            .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            .stringByReplacingOccurrencesOfString(" ", withString: "+")
    }
}
