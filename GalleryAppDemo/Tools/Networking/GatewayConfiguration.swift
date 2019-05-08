//
//  GatewayConfiguration.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation

enum GatewayConfiguration {
    
    static let apiKey = "23567b218376f79d9415"
    
    static let scheme = "http"
    static let host = "195.39.233.28"
    static let port: Int? = 8035
    
    static let url: URL = {
        var components = URLComponents()
        
        components.scheme = scheme
        components.host = host
        components.port = port
        
        return components.url!
    }()
    
}
