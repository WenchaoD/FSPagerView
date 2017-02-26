//
//  FSPagerViewLayoutAttributes.swift
//  FSPagerViewExample
//
//  Created by Wenchao Ding on 26/02/2017.
//  Copyright © 2017 Wenchao Ding. All rights reserved.
//

import UIKit

open class FSPagerViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    open var itemSize: CGSize = .zero
    open var interitemSpacing: CGFloat = 0
    
    override init() {
        super.init()
    }

    
}
