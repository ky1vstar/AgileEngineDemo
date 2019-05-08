//
//  PaginationBatch.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation

class PaginationBatch {
    
    var nextPageNumber: Int
    var canLoadMore = true
    
    init(nextPageNumber: Int = 1) {
        self.nextPageNumber = nextPageNumber
    }
    
}
