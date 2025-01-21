//
//  LeftAlignedCollectionViewFlowLayout.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation
import UIKit

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var interItemSpacing: CGFloat = 8
    private var lineSpacing: CGFloat = 8
    
    init(minimumInteritemSpacing: CGFloat, minimumLineSpacing: CGFloat) {
        super.init()
        self.interItemSpacing = minimumInteritemSpacing
        self.lineSpacing = minimumLineSpacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        scrollDirection = .vertical
        minimumInteritemSpacing = interItemSpacing
        minimumLineSpacing = lineSpacing
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // Create a copy to avoid warnings
        let attributesCopy = attributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        for layoutAttribute in attributesCopy {
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        
        return attributesCopy
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
