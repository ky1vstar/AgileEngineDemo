//
//  PhotoItem.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class PhotoItem: Mappable {
    
    var id: String?
    var author: String?
    var camera: String?
    var croppedURL: URL?
    var fullURL: URL?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        author <- map["author"]
        camera <- map["camera"]
        croppedURL <- (map["cropped_picture"], URLTransform())
        fullURL <- (map["full_picture"], URLTransform())
    }
    
}

// MARK: - IdentifiableType
extension PhotoItem: IdentifiableType {
    
    typealias Identity = String.Identity
    
    var identity: String.Identity {
        return (id ?? "").identity
    }
    
}

// MARK: - Equatable
extension PhotoItem: Equatable {
    
    static func == (lhs: PhotoItem, rhs: PhotoItem) -> Bool {
        return lhs.id == rhs.id
    }

}
