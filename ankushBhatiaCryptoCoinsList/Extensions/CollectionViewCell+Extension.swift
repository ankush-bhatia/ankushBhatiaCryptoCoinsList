//
//  CollectionViewCell+Extensions.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func registerClassWithDefaultIdentifier(cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.defaultIdentifier)
    }
    
    func dequeueReusableCellWithDefaultIdentifier<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: T.defaultIdentifier, for: indexPath) as! T
    }
 }
