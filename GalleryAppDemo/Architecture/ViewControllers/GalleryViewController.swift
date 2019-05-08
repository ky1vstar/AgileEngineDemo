//
//  GalleryViewController.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxOptional
import RxDataSources_Texture

private let interitemSpacing: CGFloat = 8
private let columnCount: CGFloat = 2

class GalleryViewController: ASViewController<ASCollectionNode> {
    
    let viewModel = GalleryViewModel()
    private var isFetching = false
    
    let refreshControl = UIRefreshControl()
    private let activityView = UIActivityIndicatorView(style: .white)
    private lazy var activityItem = UIBarButtonItem(customView: activityView)
    
    // MARK: - Init & deinit
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = interitemSpacing
        layout.minimumLineSpacing = interitemSpacing
        layout.sectionInset = UIEdgeInsets(top: interitemSpacing, left: interitemSpacing, bottom: interitemSpacing, right: interitemSpacing)
        
        let collectionNode = ASCollectionNode(collectionViewLayout: layout)
        
        super.init(node: collectionNode)
        
        automaticallyAdjustRangeModeBasedOnViewEvents = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .groupTableViewBackground
        
        setupNavigationBar()
        setupCollectionNode()
        
        fetchPhotos(refreshing: true)
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationController!.navigationBar.barStyle = .black
        navigationController!.navigationBar.tintColor = .white
        
        title = "Gallery app"
        
        viewModel
            .activityIndicator
            .asObservable()
            .distinctUntilChanged()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let `self` = self else { return }
                
                self.navigationItem.setRightBarButton(isLoading ? self.activityItem : nil, animated: true)
                
                if isLoading {
                    self.activityView.startAnimating()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func setupCollectionNode() {
        node.leadingScreensForBatching = 2
        node.layoutInspector = self
        node.delegate = self
        
        // RefreshControl
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                self?.fetchPhotos(refreshing: true)
            })
            .disposed(by: rx.disposeBag)
        
        node.view.refreshControl = refreshControl
        
        // DataSource
        let dataSource = RxASCollectionSectionedAnimatedDataSource<GallerySectionModel>(configureCellBlock: { (dataSource, collectionNode, indexPath, photo) -> ASCellNodeBlock in
            return {
                PhotoCellNode(photo: photo)
            }
        })
        
        viewModel
            .dataSource
            .map { [$0] }
            .bind(to: node.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
    
    // MARK: - Loading
    private func fetchPhotos(refreshing: Bool, with context: ASBatchContext? = nil) {
        if isFetching {
            context?.completeBatchFetching(true)
            return
        }
        isFetching = true
        
        viewModel
            .fetchPhotos(refreshing: refreshing)
            .do(onDispose: { context?.completeBatchFetching(true) })
            .subscribe({ [weak self] event in
                guard let `self` = self else { return }
                
                if let error = event.error {
                    self.handleError(error)
                }
                
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                
                self.isFetching = false
            })
            .disposed(by: rx.disposeBag)
    }
    
    // MARK: - Error handling
    private func handleError(_ error: Error) {
        let controller = UIAlertController(title: "Error occured", message: "\(error)", preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(controller, animated: true, completion: nil)
    }

}

// MARK: - GalleryViewController
extension GalleryViewController: ASCollectionDelegate {
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return !isFetching
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        DispatchQueue.main.async {
            self.fetchPhotos(refreshing: false, with: context)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        collectionNode.deselectItem(at: indexPath, animated: true)
        
        let controller = PhotosViewController(initialPhotoIndex: indexPath.item)
        controller.dataSource = self
        controller.delegate = self
        
        navigationController!.pushViewController(controller, animated: true)
    }
    
}

// MARK: - ASCollectionViewLayoutInspecting
extension GalleryViewController: ASCollectionViewLayoutInspecting {
    
    func scrollableDirections() -> ASScrollDirection {
        return ASScrollDirectionVerticalDirections
    }
    
    func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        let columnWidth = (collectionView.frame.width - interitemSpacing * (columnCount + 1)) / columnCount
        
        return ASSizeRangeMake(CGSize(width: columnWidth, height: columnWidth))
    }
    
}

// MARK: - PhotosViewControllerDataSource
extension GalleryViewController: PhotosViewControllerDataSource {
    
    func numberOfPhotos(in photosViewController: PhotosViewController) -> Int {
        return node.numberOfItems(inSection: 0)
    }
    
    func photosViewController(_ photosViewController: PhotosViewController, indexForPhoto photo: PhotosViewControllerPhoto) -> Int {
        guard let cellNode = photo as? PhotoCellNode else { return 0 }
        
        return node.indexPath(for: cellNode)?.item ?? 0
    }
    
    func photosViewController(_ photosViewController: PhotosViewController, photoForIndex index: Int) -> PhotosViewControllerPhoto? {
        guard index >= 0, index < node.numberOfItems(inSection: 0) else { return nil }
        
        return node.nodeForItem(at: IndexPath(item: index, section: 0)) as? PhotosViewControllerPhoto
    }
    
}

// MARK: - PhotosViewControllerDelegate
extension GalleryViewController: PhotosViewControllerDelegate {
    
    func photosViewController(_ photosViewController: PhotosViewController, didNavigateTo photo: PhotosViewControllerPhoto, at index: Int) {
        node.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: false)
    }
    
}
