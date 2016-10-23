import Foundation
import Moya

// In production, we would use a more secure way of storing and retrieving our API keys.
// However, we are using Giphy's public API key and hard-coding is acceptable for example purposes.
private let API_KEY = "dc6zaTOxFJmzC"

enum GiphyAPI {
    case search(query: String)
    case trending
}

extension GiphyAPI: TargetType {
    
    public var task: Task {
        return .request
    }

    
    var baseURL: URL { return URL(string: "https://api.giphy.com/v1/gifs")! }
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        case .trending:
            return "/trending"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search, .trending:
            return .GET
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .search (let query):
            return ["q": query.PlusEncodedString as AnyObject, "api_key": API_KEY, "limit": 100]
        case .trending:
            return ["api_key": API_KEY as AnyObject, "limit": 100]
        }
    }
    
    var sampleData: Data {
        switch self {
        case .search:
            return stubbedResponse("Search")
        case .trending:
            return stubbedResponse("Trending")
        }
    }
    
//    var multipartBody: [MultipartFormData]? {
//        return nil
//    }
   
    // Helper for stubbed responses
    fileprivate func stubbedResponse(_ filename: String) -> Data! {
        class TestClass: NSObject {}
        
        let bundle = Bundle(for: TestClass.self)
        let path = bundle.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
}

extension String {
    
    var TrimmedString: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var PlusEncodedString: String {
        return self
            .TrimmedString
            .replacingOccurrences(of: " ", with: "+")
    }
}
