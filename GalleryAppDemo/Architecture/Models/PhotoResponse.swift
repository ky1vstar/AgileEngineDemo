//
//  PhotoResponse.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import ObjectMapper

class PhotoResponse: Mappable {
    
    var photos = [PhotoItem]()
    var pageNumber: Int?
    var hasMore = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        photos <- map["pictures"]
        pageNumber <- map["page"]
        hasMore <- map["hasMore"]
    }
    
}
