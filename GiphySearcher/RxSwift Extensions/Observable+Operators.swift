import RxSwift

// Reference: https://github.com/artsy/eidolon/blob/master/Kiosk/Observable%2BOperators.swift

private let backgroundScheduler = SerialDispatchQueueScheduler(qos: .default)

extension Observable where Element: Equatable {
    
    func ignore(_ value: Element) -> Observable<Element> {
        return filter { (e) -> Bool in
            return value != e
        }
    }
    
    func mapReplace<T>(_ value: T) -> Observable<T> {
        return map { _ -> T in
            return value
        }
    }
    
    func dispatchAsyncMainScheduler() -> Observable<E> {
        return self.observeOn(backgroundScheduler).observeOn(MainScheduler.instance)
    }
}
