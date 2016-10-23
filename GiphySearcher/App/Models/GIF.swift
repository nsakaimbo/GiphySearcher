import Foundation
import SwiftyJSON

protocol JSONAbleType {
    static func fromJSON(_: [String: AnyObject]) -> Self
}

final class GIF: NSObject, JSONAbleType {
    
    let id: String
    let trending_datetime: String
    let rating: String
    
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
         large_height: String,
         rating: String) {
        
        self.id = id
        self.rating = rating
        
        self.trending_datetime = trended_datetime
        
        self.url_thumbnail = url_thumbnail
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        
        self.url_large = url_large
        self.large_width = large_width
        self.large_height = large_height
        
        super.init()
    }
    
    static func fromJSON(_ json: [String: AnyObject]) -> GIF {
        let json = JSON(json)
        
        let id = json["id"].stringValue
        let trended_datetime = json["trending_datetime"].stringValue
        let url_thumbnail = json["images"]["fixed_width"]["url"].stringValue
        let thumbnail_width = json["images"]["fixed_width"]["width"].stringValue
        let thumbnail_height = json["images"]["fixed_width"]["height"].stringValue
        let url_large = json["images"]["original"]["url"].stringValue
        let large_width = json["images"]["original"]["width"].stringValue
        let large_height = json["images"]["original"]["height"].stringValue
        let rating = json["rating"].stringValue
        
        return GIF(id: id,
                   trended_datetime: trended_datetime,
                   url_thumbnail: url_thumbnail,
                   thumbnail_width: thumbnail_width,
                   thumbnail_height: thumbnail_height,
                   url_large: url_large,
                   large_width: large_width,
                   large_height: large_height,
                   rating: rating)
    }
}
