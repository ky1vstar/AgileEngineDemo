//
//  PhotoViewController.swift
//  GalleryAppDemo
//
//  Created by KY1VSTAR on 5/8/19.
//  Copyright © 2019 KY1VSTAR. All rights reserved.
//

import UIKit
import PINRemoteImage

class PhotoViewController: UIViewController {
    
    let photo: PhotosViewControllerPhoto
    private let viewModel: PhotoViewModel
    
    private let activityView = UIActivityIndicatorView(style: .white)
    private let imageView = UIImageView()
    private let overlayLabel = UILabel()
    
    // MARK: - Init & deinit
    init(photo: PhotosViewControllerPhoto) {
        self.photo = photo
        viewModel = PhotoViewModel(photo: photo)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageView()
        setupActivityView()
        setupOverlayLabel()
        setupObserver()
        updatePhoto()
    }
    
    // MARK: - Setup
    private func setupImageView() {
        imageView.image = photo.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupActivityView() {
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityView)
        
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupOverlayLabel() {
        overlayLabel.numberOfLines = 2
        overlayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayLabel)
        
        overlayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        overlayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        overlayLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    private func setupObserver() {
        photo
            .photoVariable
            .subscribe(onNext: { [weak self] photo in
                guard let `self` = self else { return }
                
                // imageView
                self.imageView.pin_setImage(from: photo.fullURL ?? photo.croppedURL, completion: { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.updatePhoto()
                    }
                })
                
                // overlayLabel
                let attrStr = NSMutableAttributedString(string: photo.author ?? "", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 17)])
                
                attrStr.append(NSAttributedString(string: "\n"))
                
                attrStr.append(NSAttributedString(string: photo.camera ?? "", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15)]))
                
                self.overlayLabel.attributedText = attrStr
            })
            .disposed(by: rx.disposeBag)
    }
    
    // MARK: - Handling photo update
    private func updatePhoto() {
        if imageView.image == nil {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }
    
}
