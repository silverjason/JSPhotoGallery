//
//  UICVCellLoading.swift
//  WorkyardCrew
//
//  Created by Jason Silver on 13/5/19.
//  Copyright © 2019 Workyard Pty Ltd. All rights reserved.
//

import Foundation

protocol UICVCellLoading where Self: UICollectionViewCell {
    static var identifier: String { get }
    static var nibName: String { get }
}

extension UICVCellLoading where Self: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
}
