//
//  PhotosViewControllerDelegate.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import Foundation

protocol PhotosViewControllerDelegate: class {
    
    func photosViewController(_ photosViewController: PhotosViewController, didNavigateTo photo: PhotosViewControllerPhoto, at index: Int)
    
}

// MARK: - Optional
extension PhotosViewControllerDelegate {
    
    func photosViewController(_ photosViewController: PhotosViewController, didNavigateTo photo: PhotosViewControllerPhoto, at index: Int) {}
    
}
