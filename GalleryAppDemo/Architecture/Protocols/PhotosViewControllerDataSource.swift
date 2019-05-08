//
//  PhotosViewControllerDataSource.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation

protocol PhotosViewControllerDataSource: class {
    
    func numberOfPhotos(in photosViewController: PhotosViewController) -> Int
    
    func photosViewController(_ photosViewController: PhotosViewController, indexForPhoto photo: PhotosViewControllerPhoto) -> Int
    
    func photosViewController(_ photosViewController: PhotosViewController, photoForIndex index: Int) -> PhotosViewControllerPhoto?
    
}
