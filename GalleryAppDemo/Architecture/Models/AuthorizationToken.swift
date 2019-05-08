//
//  AuthorizationToken.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import ObjectMapper

class AuthorizationToken: Mappable {
    
    var token: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        token <- map["token"]
    }
    
}
