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
        let storyboard = UIStoryboard(name: Self.storyboard.name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: Self.storyboardID) as! Self
    }
    
    static func instantiateNC(isPortrait: Bool = true, isNavigationBarHidden: Bool = true) -> UINavigationController {
        let vc = Self.instantiate()
        let nc = UINavigationController(rootViewController: vc)
        nc.shouldAutorotate = false
        nc.isNavigationBarHidden = isNavigationBarHidden
        return nc
    }
}
