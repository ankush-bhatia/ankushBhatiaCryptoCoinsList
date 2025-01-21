//
//  UIFont+Extensions.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation
import UIKit

extension UIFont {
    
    enum Title {
        
        static var light = UIFont.systemFont(ofSize: 18, weight: .light)
        static var lightSmall = UIFont.systemFont(ofSize: 14, weight: .light)
        static var semibold = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    enum Description {
        
        static var semibold = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
}
