//
//  AuthorizationRouter.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional
import Alamofire

class AuthorizationRouter: BaseRouter {
    
    class func auth() -> Observable<String> {
        return unauthorizedRequest(method: .post,
                                   path: "/auth",
                                   parameters: ["apiKey": GatewayConfiguration.apiKey],
                                   encoding: JSONEncoding.default)
            .responseObject(AuthorizationToken.self)
            .map { $0.token }
            .errorOnNil()
    }
    
}
