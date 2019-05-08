//
//  RxVariable.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

final class RxVariable<Element>: ObservableType, HasDisposeBag {
    
    typealias E = Element
    
    private let relay: BehaviorRelay<Element>
    
    var value: Element {
        get {
            return relay.value
        }
        set {
            relay.accept(newValue)
        }
    }
    
    init(_ value: Element) {
        relay = BehaviorRelay(value: value)
    }
    
    func update() {
        relay.accept(relay.value)
    }
    
    public func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, Element == O.E {
        return relay.subscribe(observer)
    }
    
    public func asObservable() -> Observable<Element> {
        return relay.asObservable()
    }
    
}

private typealias SwiftSucksCocks = RxVariable

extension RxVariable {
    
    func unsafeCast<T>(_: T.Type = T.self) -> RxVariable<T> {
        let newVariable = SwiftSucksCocks(value as! T)
        
        asObservable()
            .map { $0 as! T }
            .bind(to: newVariable)
            .disposed(by: disposeBag)
        
        return newVariable
    }
    
}

extension ObservableType {
    
    func bind(to variable: RxVariable<E>) -> Disposable {
        return subscribe { e in
            switch e {
            case let .next(element):
                variable.value = element
            case let .error(error):
                print("Binding error to behavior relay: \(error)")
            case .completed:
                break
            }
        }
    }
    
    func bind(to variable: RxVariable<Optional<E>>) -> Disposable {
        return map { value -> Optional<E> in
            return value
            }
            .bind(to: variable)
    }
    
}

