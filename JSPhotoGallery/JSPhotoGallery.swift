//
//  JSPhotoGallery.swift
//  JSPhotoGallery
//
//  Created by Jason Silver on 7/6/19.
//  Copyright © 2019 Jason Silver. All rights reserved.
//

import Foundation

public struct JSPhotoGallery {
    
    public static var settings = Settings()
    
    public struct Settings {
        public var backgroundColor: UIColor = .white
        public var navBackgroundColor: UIColor = .white
        public var navTitleColor: UIColor = .white
        public var navTitle: String = "Photos"
    }
    
    public static func create(imageURLs: [URL]? = nil,
                              images: [UIImage]? = nil,
                              initialIndex: Int = 0,
                              shouldStartInFullScreen: Bool = true,
                              delegate: JSPhotoGalleryDelegate? = nil,
                              animated: Bool = true,
                              completion: (() -> Void)? = nil) -> UINavigationController {
        
        if imageURLs == nil && images == nil {
            assertionFailure("List of image urls and images cannot both be nil")
        }
        
        let storyboard = UIStoryboard(name: JSPhotoGalleryVC.Constants.storyboardName,
                                      bundle: Bundle(identifier: JSPhotoGalleryVC.Constants.bundleID))
        let photoGallery = storyboard.instantiateViewController(withIdentifier: JSPhotoGalleryVC.Constants.storyboardID) as! JSPhotoGalleryVC
        
        photoGallery.imageURLs = imageURLs
        photoGallery.images = images
        photoGallery.initialIndex = initialIndex
        photoGallery.shouldStartInFullScreen = shouldStartInFullScreen
        photoGallery.delegate = delegate
        
        return UINavigationController(rootViewController: photoGallery)
    }
}
