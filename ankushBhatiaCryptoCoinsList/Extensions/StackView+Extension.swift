//
//  StackView+Extension.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation
import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addArrangedSubview(subview)
        }
    }
}
