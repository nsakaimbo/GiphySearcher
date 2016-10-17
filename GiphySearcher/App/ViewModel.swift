import Foundation
import NSObject_Rx
import RxSwift

protocol ViewModelType {
    
    var API: Networking { get }
    var GIFArray: Variable<Array<GIF>> { get }
    var endpoint: GiphyAPI { get }
    var numberOfGIFs: Int { get }
    var updatedContents: Observable<Bool> { get }
    
    func GIFAtIndexPath(_ indexPath: IndexPath) -> GIF
    
    func GIFViewModelAtIndexPath(_ indexPath: IndexPath, canShowTrendingIcon: Bool) -> GIFViewModel
}

class ViewModel: NSObject, ViewModelType {
    
    var API: Networking
   
    var GIFArray = Variable<Array<GIF>>([])
    
    let endpoint: GiphyAPI
  
    init(API: Networking, endpoint: GiphyAPI) {
        
        self.API = API
        self.endpoint = endpoint
        
        super.init()
        
        fetch(API)
            .subscribe(onNext: {
                self.GIFArray.value += $0
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    var numberOfGIFs: Int {
        return GIFArray.value.count
    }
    
    func GIFAtIndexPath(_ indexPath: IndexPath) -> GIF {
        return GIFArray.value[indexPath.item]
    }
    
    func GIFViewModelAtIndexPath(_ indexPath: IndexPath, canShowTrendingIcon: Bool = false) -> GIFViewModel {
        let gif = GIFAtIndexPath(indexPath)
        return GIFViewModel(gif: gif, canShowTrendingIcon: canShowTrendingIcon)
    }
    
    var updatedContents: Observable<Bool> {
        return GIFArray
            .asObservable()
            .map { $0.count > 0 }
            .ignore(false)
    }
    
    func fetch(_ API: Networking) -> Observable<[GIF]> {
        return API.provider.request(self.endpoint)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToObjectArray(GIF.self)
            .catchErrorJustReturn([])
            .observeOn(MainScheduler.instance)
    }
}
