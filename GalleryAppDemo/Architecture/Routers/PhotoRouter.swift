//
//  PhotoRouter.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class PhotoRouter: BaseRouter {
    
    class func fetchPhotos(with batch: PaginationBatch) -> Observable<[PhotoItem]> {
        return authorizedRequest(method: .get,
                                 path: "/images",
                                 parameters: ["page": batch.nextPageNumber])
            .responseObject(PhotoResponse.self)
            .do(onNext: { response in
                batch.nextPageNumber = (response.pageNumber ?? batch.nextPageNumber) + 1
                batch.canLoadMore = response.hasMore
            })
            .map { $0.photos }
    }
    
    class func fetchDetails(for photo: PhotoItem) -> Observable<PhotoItem> {
        return authorizedRequest(method: .get,
                                 path: "/images/\(photo.id ?? "")")
            .responseObject()
    }
    
}
