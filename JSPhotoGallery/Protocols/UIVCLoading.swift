//
//  UIVCLoading.swift
//  WorkyardCrew
//
//  Created by M Akhzary on 7/2/19.
//  Copyright © 2019 Workyard Pty Ltd. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case photoGallery = "PhotoGallery"
}

protocol UIVCLoading where Self : UIViewController {
    static var storyboard: Storyboard { get }
    static var storyboardID: String { get }
}

extension UIVCLoading where Self : UIViewController {
    
    static var storyboardID: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: Self.storyboard.rawValue, bundle: Bundle(identifier: "org.cocoapods.JSPhotoGallery"))
        return storyboard.instantiateViewController(withIdentifier: Self.storyboardID) as! Self
    }

}
