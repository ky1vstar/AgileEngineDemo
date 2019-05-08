//
//  PhotosViewControllerPhoto.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import UIKit
import RxSwift

protocol PhotosViewControllerPhoto: class {

    var image: UIImage? { get }
    
    var photoVariable: RxVariable<PhotoItem> { get }
    
}
