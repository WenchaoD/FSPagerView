//
//  FSPagerViewLayoutAttributes.swift
//  FSPagerViewExample
//
//  Created by Wenchao Ding on 26/02/2017.
//  Copyright © 2017 Wenchao Ding. All rights reserved.
//

import UIKit

open class FSPagerViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    open var rotationY: CGFloat = 0
    open var pivot = CGPoint(x:0.5, y:0.5)
    open var position: CGFloat = 0
    open var interitemSpacing: CGFloat = 0
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? FSPagerViewLayoutAttributes else {
            return false
        }
        var isEqual = super.isEqual(object)
        isEqual = isEqual && (self.rotationY == object.rotationY)
        isEqual = isEqual && (self.pivot == object.pivot)
        isEqual = isEqual && (self.position == object.position)
        isEqual = isEqual && (self.interitemSpacing == object.interitemSpacing)
        return isEqual
    }
    
    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! FSPagerViewLayoutAttributes
        copy.rotationY = self.rotationY
        copy.pivot = self.pivot
        copy.position = self.position
        copy.interitemSpacing = self.interitemSpacing
        return copy
    }
    
}
