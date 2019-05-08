//
//  PhotoViewModel.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx

class PhotoViewModel: HasDisposeBag {
    
    private let photo: PhotosViewControllerPhoto
    
    init(photo: PhotosViewControllerPhoto) {
        self.photo = photo
        
        fetchPhotoDetails()
    }
    
    private func fetchPhotoDetails() {
        PhotoRouter
            .fetchDetails(for: photo.photoVariable.value)
            .observeOn(MainScheduler.instance)
            .bind(to: photo.photoVariable)
            .disposed(by: disposeBag)
    }
    
}
