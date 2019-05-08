//
//  RxVariable+DataSource.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

extension RxVariable: IdentifiableType where Element: IdentifiableType {
    
    typealias Identity = Element.Identity
    
    var identity: Identity {
        return value.identity
    }
    
}

extension RxVariable: Equatable where Element: Equatable {
    
    static func == (lhs: RxVariable<Element>, rhs: RxVariable<Element>) -> Bool {
        return lhs.value == rhs.value
    }
    
}
