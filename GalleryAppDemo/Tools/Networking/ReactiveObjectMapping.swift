//
//  ReactiveObjectMapping.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RxSwift
import ObjectMapper

fileprivate let backgroundQueue = DispatchQueue(label: "Alamofire.DataRequest.queue", qos: .background, attributes: .concurrent)

// MARK: - DataRequest
extension DataRequest: ReactiveCompatible {}

extension ObservableType where E: DataRequest {
    
    func responseObject<T: Mappable>(_: T.Type = T.self, keyPath: String? = nil, context: MapContext? = nil) -> Observable<T> {
        return flatMap {
            $0.rx.responseObject(T.self, keyPath: keyPath, context: context)
        }
        .catchAuthorization()
    }
    
    func responseArray<T: Mappable>(_: T.Type = T.self, keyPath: String? = nil, context: MapContext? = nil) -> Observable<[T]> {
        return flatMap {
            $0.rx.responseArray(T.self, keyPath: keyPath, context: context)
        }
    }
    
}

private extension Reactive where Base: DataRequest {
    
    func responseObject<T: Mappable>(_: T.Type, keyPath: String?, context: MapContext?) -> Observable<T> {
        return Observable.create({ observer -> Disposable in
            let request = self.base

            request
                .validate()
                .responseObject(queue: backgroundQueue, keyPath: keyPath, mapToObject: nil, context: context, completionHandler: { (response: DataResponse<T>) in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create(with: request.cancel)
        })
    }
    
    func responseArray<T: Mappable>(_: T.Type, keyPath: String?, context: MapContext?) -> Observable<[T]> {
        return Observable.create({ observer -> Disposable in
            let request = self.base
            
            request
                .validate()
                .responseArray(queue: backgroundQueue, keyPath: keyPath, context: context, completionHandler: { (response: DataResponse<[T]>) in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create(with: request.cancel)
        })
    }

}
