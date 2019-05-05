//
//  Waaatcher+Rx.swift
//  Waaatcher
//
//  Created by chen he on 2019/5/5.
//

import Foundation
import RxSwift

/*
 Extend Waaatcher with `rx` proxy.
 */
extension Waaatcher: ReactiveCompatible { }

public
extension Reactive where Base: Waaatcher {
    
    public var FSEventObservable: Observable<WaaaFSEvent> {
        
        return Observable.create { [weak waaatcher = self.base] observer in
            
            guard let realWatcher = waaatcher else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            // replace callback block
            let oldCallback = realWatcher.watcherEventCallback
            realWatcher.watcherEventCallback = {
                oldCallback?($0)
                $0.forEach { observer.onNext($0) }
            }
            
            if !realWatcher.isWatching {
                do {
                    _ = try realWatcher.start()
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                waaatcher?.stop()
            }
        }
    }
    
}
