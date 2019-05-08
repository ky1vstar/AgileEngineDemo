//
//  Authorization.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

// MARK: - AuthorizationError
enum AuthorizationError: Error {
    
    case unauthorized
    
}

// MARK: - Authorization
enum Authorization {
    
    static let lock = NSLock()
    private static var _token: String?
    
    static var token: String? {
        get {
            lock.lock(); defer { lock.unlock() }
            
            return _token
        }
        set {
            lock.lock(); defer { lock.unlock() }
            
            _token = newValue
        }
    }
    
}

// MARK: - Catch authorization
extension ObservableType {
    
    func catchAuthorization() -> Observable<E> {
        return retryWhen { error -> Observable<String> in
            return error
                .flatMapLatest({ error -> Observable<String> in
                    var isUnauthorizedError = false
                    
                    if let afError = error as? AFError,
                        case .responseValidationFailed(let reason) = afError,
                        case .unacceptableStatusCode(let code) = reason,
                        code == 401 {
                        isUnauthorizedError = true
                    }
                    
                    if !isUnauthorizedError,
                        let authorizationError = error as? AuthorizationError,
                        authorizationError == .unauthorized {
                        isUnauthorizedError = true
                    }
                    
                    guard isUnauthorizedError else {
                        throw error
                    }
                    
                    return AuthorizationRouter
                        .auth()
                        .do(onNext: { token in
                            Authorization.token = token
                        })
                })
        }
    }
    
}
