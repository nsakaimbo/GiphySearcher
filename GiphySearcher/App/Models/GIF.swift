import Foundation
import SwiftyJSON

protocol JSONAbleType {
    static func fromJSON(_: [String: AnyObject]) -> Self
}

final class GIF: NSObject, JSONAbleType {
    
    let id: String
    let trending_datetime: String
    
    let url_thumbnail: String
    let thumbnail_width: String
    let thumbnail_height: String
    
    let url_large: String
    let large_width: String
    let large_height: String
    
    init(id: String,
         trended_datetime: String,
         url_thumbnail: String,
         thumbnail_width: String,
         thumbnail_height: String,
         url_large: String,
         large_width: String,
         large_height: String) {
        
        self.id = id
        
        self.trending_datetime = trended_datetime
        
        self.url_thumbnail = url_thumbnail
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        
        self.url_large = url_large
        self.large_width = large_width
        self.large_height = large_height
        
        super.init()
    }
    
    static func fromJSON(json: [String: AnyObject]) -> GIF {
        let json = JSON(json)
        
        let id = json["id"].stringValue
        let trended_datetime = json["trending_datetime"].stringValue
        let url_thumbnail = json["images"]["fixed_width"]["url"].stringValue
        let thumbnail_width = json["images"]["fixed_width"]["width"].stringValue
        let thumbnail_height = json["images"]["fixed_width"]["height"].stringValue
        let url_large = json["images"]["original"]["url"].stringValue
        let large_width = json["images"]["original"]["width"].stringValue
        let large_height = json["images"]["original"]["height"].stringValue
        
        return GIF(id: id,
                   trended_datetime: trended_datetime,
                   url_thumbnail: url_thumbnail,
                   thumbnail_width: thumbnail_width,
                   thumbnail_height: thumbnail_height,
                   url_large: url_large,
                   large_width: large_width,
                   large_height: large_height)
    }
}

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = NSTimeZone(name: "UTC")
    return formatter
}()

extension GIF {
    
    // We use this to show the user if a GIF has ever trended
    // Note: Giphy was founded in February 2013. The API appears to use a placeholder trending date of 1970-01-01.
    // We return trending == true if date is later than or equal to company created date as a proxy.
    // https://en.wikipedia.org/wiki/Giphy#Beginnings_and_early_history
    var hasEverTrended: Bool {
        guard let date = dateFormatter.dateFromString(trending_datetime) else {
            return false
        }
        return compare(date)
    }
    
    private func compare(date: NSDate) -> Bool {
        
        let components = NSDateComponents()
        components.day = 1
        components.month = 2
        components.year = 2013
        let compareDate = NSCalendar.currentCalendar().dateFromComponents(components)!
        
        switch date.compare(compareDate) {
        case .OrderedSame, .OrderedDescending:
            return true
        default:
            return false
        }
    }
}
