//
//  Tableview+Extensions.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerClassWithDefaultIdentifier(cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: cellClass.defaultIdentifier)
    }
    
    func dequeueReusableCellWithDefaultIdentifier<T: UITableViewCell>() -> T {
        dequeueReusableCell(withIdentifier: T.defaultIdentifier) as! T
    }
}
