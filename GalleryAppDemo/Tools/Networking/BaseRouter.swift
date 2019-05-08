//
//  BaseRouter.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class BaseRouter {
    
    static let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    
    private static let sessionDelegate = SessionDelegate()
    static let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.httpShouldSetCookies = false
        configuration.httpCookieAcceptPolicy = .never
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        
        
        return SessionManager(configuration: configuration)
    }()
    
    class func authorizedRequest(method: Alamofire.HTTPMethod,
                                 path: String,
                                 parameters: Parameters = [:],
                                 encoding: ParameterEncoding = URLEncoding.default,
                                 headers: HTTPHeaders? = nil) -> Observable<DataRequest> {
        
        return Observable
            .create({ (observer: AnyObserver<String>) -> Disposable in
                if let token = Authorization.token {
                    observer.onNext(token)
                    observer.onCompleted()
                } else {
                    observer.onError(AuthorizationError.unauthorized)
                }
                
                return Disposables.create()
            })
            .flatMapLatest { token -> Observable<DataRequest> in
                var headers = headers ?? [:]
                headers["Authorization"] = "Bearer \(token)"
                
                return unauthorizedRequest(method: method, path: path, parameters: parameters, encoding: encoding, headers: headers)
            }
    }
    
    class func unauthorizedRequest(method: Alamofire.HTTPMethod,
                                   path: String,
                                   parameters: Parameters = [:],
                                   encoding: ParameterEncoding = URLEncoding.default,
                                   headers: HTTPHeaders? = nil) -> Observable<DataRequest> {
        
        return Observable.create({ observer -> Disposable in
            let request = sessionManager.request(GatewayConfiguration.url.appendingPathComponent(path), method: method, parameters: parameters, encoding: encoding, headers: headers)
            
            observer.onNext(request)
            request.response(completionHandler: { response in
                if let error = response.error {
                    observer.onError(error)
                } else {
                    observer.onCompleted()
                }
            })
            
            return Disposables.create(with: request.cancel)
        })
    }
    
}
