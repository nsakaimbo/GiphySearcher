import Foundation
import NSObject_Rx
import RxSwift

protocol ViewModelType {
    var API: Networking { get }
    var GIFArray: Variable<Array<GIF>> { get }
    var endpoint: GiphyAPI { get }
}

class ViewModel: NSObject, ViewModelType {
    
    var API: Networking
   
    var GIFArray = Variable<Array<GIF>>([])
    
    let endpoint: GiphyAPI
  
    init(API: Networking, endpoint: GiphyAPI) {
        
        self.API = API
        self.endpoint = endpoint
        
        super.init()
        
        fetchTrending(API)
            .subscribeNext({
                self.GIFArray.value += $0
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    var numberOfGIFs: Int {
        return GIFArray.value.count
    }
    
    func GIFAtIndexPath(indexPath: NSIndexPath) -> GIF {
        return GIFArray.value[indexPath.item]
    }
   
    // MARK: Private Methods
    
    private func fetchTrending(API: Networking) -> Observable<[GIF]> {
        return API.provider.request(self.endpoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObjectArray(GIF.self)
            .catchErrorJustReturn([])
            .observeOn(MainScheduler.instance)
    }
}