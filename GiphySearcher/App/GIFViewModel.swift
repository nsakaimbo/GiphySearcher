import Foundation
import RxCocoa
import RxSwift
import NSObject_Rx

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone(identifier: "UTC")
    return formatter
}()

final class GIFViewModel: NSObject {
    
    let gif: GIF
    
    var hasEverTrended: BehaviorSubject<Bool>
    var canShowTrendingIcon: BehaviorSubject<Bool>
    
    init(gif: GIF, canShowTrendingIcon: Bool = false) {
        self.gif = gif
        
        let trended = GIFViewModel.setHasEverTrended(self.gif)
        hasEverTrended = BehaviorSubject<Bool>(value: trended)
       
        // false by default unless override in initializer
        self.canShowTrendingIcon = BehaviorSubject<Bool>(value: canShowTrendingIcon)
        
        super.init()
    }
   
    var thumbnailURL: URL? {
        return URL(string: self.gif.url_thumbnail)
    }
    
    // MARK: Helpers
    // We use this to show the user if a GIF has ever trended
    // Note: Giphy was founded in February 2013. The API appears to use a placeholder trending date of 1970-01-01.
    // We return trending == true if date is later than or equal to company created date as a proxy.
    // https://en.wikipedia.org/wiki/Giphy#Beginnings_and_early_history
    fileprivate class func setHasEverTrended(_ gif:GIF) -> Bool {
        guard let date = dateFormatter.date(from: gif.trending_datetime) else {
            return false
        }
        return compare(date)
    }
    
    fileprivate class func compare(_ date: Date) -> Bool {
        
        var components = DateComponents()
        components.day = 1
        components.month = 2
        components.year = 2013
        let compareDate = Calendar.current.date(from: components)!
        
        switch date.compare(compareDate) {
        case .orderedSame, .orderedDescending:
            return true
        default:
            return false
        }
    }
}
