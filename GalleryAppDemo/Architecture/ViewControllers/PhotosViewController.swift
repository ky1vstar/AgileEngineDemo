//
//  PhotosViewController.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    private let initialPhotoIndex: Int
    weak var delegate: PhotosViewControllerDelegate?
    weak var dataSource: PhotosViewControllerDataSource?
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    // MARK: - Init & deinit
    init(initialPhotoIndex: Int = 0) {
        self.initialPhotoIndex = initialPhotoIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black

        setupNavigationBar()
        setupPageViewController()
        updateTitle(with: initialPhotoIndex)
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
    }
    
    private func setupPageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        
        pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        pageViewController.didMove(toParent: self)
        
        if let initialViewController = newPhotoViewController(for: initialPhotoIndex) {
            pageViewController.setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    private func newPhotoViewController(for index: Int) -> PhotoViewController? {
        guard let dataSource = dataSource,
            let photo = dataSource.photosViewController(self, photoForIndex: index) else {
                return nil
        }
        
        return PhotoViewController(photo: photo)
    }
    
    // MARK: - Actions
    @objc private func shareButtonTapped() {
        guard let photoViewController = pageViewController.viewControllers?.first as? PhotoViewController else {
            return
        }
        
        let photo = photoViewController.photo.photoVariable.value
        let controller = UIActivityViewController(activityItems: [photo.fullURL ?? photo.croppedURL], applicationActivities: nil)
        
        present(controller, animated: true, completion: nil)
    }
    
    private func updateTitle(with index: Int) {
        let numberOfPhotos = dataSource?.numberOfPhotos(in: self) ?? 0
        
        title = "\(index + 1) of \(numberOfPhotos)"
    }
    
}

// MARK: - UIPageViewControllerDataSource
extension PhotosViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let photoViewController = viewController as! PhotoViewController
        let photoIndex = dataSource?.photosViewController(self, indexForPhoto: photoViewController.photo) ?? 0
        
        return newPhotoViewController(for: photoIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let photoViewController = viewController as! PhotoViewController
        let photoIndex = dataSource?.photosViewController(self, indexForPhoto: photoViewController.photo) ?? 0
        
        return newPhotoViewController(for: photoIndex + 1)
    }
    
}

// MARK: - UIPageViewControllerDelegate
extension PhotosViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let delegate = delegate,
            let dataSource = dataSource,
            let photoViewController = pageViewController.viewControllers?.first as? PhotoViewController else {
                return
        }
        
        let photoIndex = dataSource.photosViewController(self, indexForPhoto: photoViewController.photo)
    
        updateTitle(with: photoIndex)
        delegate.photosViewController(self, didNavigateTo: photoViewController.photo, at: photoIndex)
    }
    
}
