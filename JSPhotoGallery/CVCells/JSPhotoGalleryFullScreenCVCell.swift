//
//  PhotoGalleryFullScreenCVCell.swift
//  WorkyardCrew
//
//  Created by Jason Silver on 13/5/19.
//  Copyright © 2019 Workyard Pty Ltd. All rights reserved.
//

import UIKit

class JSPhotoGalleryFullScreenCVCell: UICollectionViewCell {
    
    
    //MARK: - Constants
    struct Constants {
        static let bundleID = "org.cocoapods.JSPhotoGallery"
        static let identifier = "JSPhotoGalleryFullScreenCVCell"
        static let nibName = "JSPhotoGalleryFullScreenCVCell"
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
}
