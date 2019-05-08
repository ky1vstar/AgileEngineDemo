//
//  GalleryViewModel.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources_Texture
import NSObject_Rx

typealias GallerySectionModel = AnimatableSectionModel<String, RxVariable<PhotoItem>>

class GalleryViewModel: HasDisposeBag {
    
    private let backgroundScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "GalleryViewModel.scheduler")
    let activityIndicator = ActivityIndicator()
    let dataSource = RxVariable(GallerySectionModel(model: "", items: []))
    private var batch = PaginationBatch()
    
    func fetchPhotos(refreshing: Bool) -> Observable<Void> {
        if refreshing {
            batch = PaginationBatch()
        }
        
        return PhotoRouter
            .fetchPhotos(with: batch)
            .observeOn(backgroundScheduler)
            .map { $0.map(RxVariable.init) }
            .do(onNext: { [weak self] photos in
                guard let `self` = self else { return }
                
                if refreshing {
                    self.dataSource.value.items = photos
                } else {
                    self.dataSource.value.items.append(contentsOf: photos)
                }
            })
            .map { _ in }
            .observeOn(MainScheduler.instance)
            .trackActivity(activityIndicator)
    }
    
}
