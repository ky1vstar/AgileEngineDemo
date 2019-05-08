//
//  PhotoCellNode.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RxSwift

class PhotoCellNode: ASCellNode {
    
    let photoVariable: RxVariable<PhotoItem>
    
    private let imageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        
        node.isUserInteractionEnabled = false
        node.clipsToBounds = true
        
        return node
    }()

    init(photo: RxVariable<PhotoItem>) {
        photoVariable = photo
        
        super.init()
        
        backgroundColor = .lightGray
        automaticallyManagesSubnodes = true
        
        photo
            .subscribe(onNext: { [weak self] photo in
                guard let `self` = self else { return }
                
                self.imageNode.url = photo.fullURL ?? photo.croppedURL
            })
            .disposed(by: rx.disposeBag)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }
    
}

// MARK: - PhotosViewControllerPhoto
extension PhotoCellNode: PhotosViewControllerPhoto {
    
    var image: UIImage? {
        return imageNode.image
    }
    
}
