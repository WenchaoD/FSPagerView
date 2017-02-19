//
//  FSPagerViewLayout.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 20/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit

class FSPagerViewLayout: UICollectionViewLayout {
    
    internal var contentSize: CGSize = .zero
    internal var leadingSpacing: CGFloat = 0
    internal var itemSpan: CGFloat = 0
    internal var needsReprepare = true
    
    fileprivate var pagerView: FSPagerView? {
        return self.collectionView?.superview?.superview as? FSPagerView
    }
    fileprivate var layoutAttributes: [IndexPath:UICollectionViewLayoutAttributes] = [:]
    
    fileprivate var isInfinite: Bool = true
    fileprivate var collectionViewSize: CGSize = .zero
    fileprivate var numberOfSections = 1
    fileprivate var numberOfItems = 0
    fileprivate var actualInteritemSpacing: CGFloat = 0
    fileprivate var actualItemSize: CGSize = .zero
    
    override init() {
        super.init()
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override open func prepare() {
        guard let collectionView = self.collectionView, let pagerView = self.pagerView else {
            return
        }
        guard self.needsReprepare || self.collectionViewSize != collectionView.frame.size else {
            return
        }
        self.needsReprepare = false
        
        self.collectionViewSize = collectionView.frame.size
        self.layoutAttributes.removeAll()

        // Calculate basic parameters/variables
        self.numberOfSections = pagerView.numberOfSections(in: collectionView)
        self.numberOfItems = pagerView.collectionView(collectionView, numberOfItemsInSection: 0)
        guard self.numberOfItems > 0 && self.numberOfSections > 0 else {
            return
        }
        
        self.actualItemSize = {
            var size = pagerView.itemSize
            if size == .zero {
                size = collectionView.frame.size
            }
            return size
        }()
        
        self.actualInteritemSpacing = {
            if let transformer = pagerView.transformer {
                return transformer.proposedInteritemSpacing()
            }
            return pagerView.interitemSpacing
        }()
        self.leadingSpacing = (collectionView.frame.width-self.actualItemSize.width)*0.5
        self.itemSpan = self.actualItemSize.width+self.actualInteritemSpacing
        
        // Calculate and cache contentSize, rather than calculating each time
        self.contentSize = {
            let numberOfItems = self.numberOfItems*self.numberOfSections
            var contentSizeWidth: CGFloat = self.leadingSpacing*2 // Leading & trailing spacing
            contentSizeWidth += CGFloat(numberOfItems-1)*self.actualInteritemSpacing // Interitem spacing
            contentSizeWidth += CGFloat(numberOfItems)*self.actualItemSize.width // Item sizes
            let contentSize = CGSize(width: contentSizeWidth, height: collectionView.frame.height)
            return contentSize
        }()
        self.adjustCollectionViewBounds()
    }
    
    override open var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        guard self.itemSpan > 0, !rect.isEmpty else {
            return layoutAttributes
        }
        let rect = rect.intersection(CGRect(origin: .zero, size: self.contentSize))
        guard !rect.isEmpty else {
            return layoutAttributes
        }
        // Calculate start position and index of certain rects
        let numberOfItemsBefore = max(Int((rect.minX-self.leadingSpacing)/self.itemSpan),0)
        let startPosition = self.leadingSpacing + CGFloat(numberOfItemsBefore)*self.itemSpan
        let startIndex = numberOfItemsBefore
        // Create layout attributes
        var itemIndex = startIndex
        var x = startPosition
        let maxPosition = min(rect.maxX,self.contentSize.width-self.actualItemSize.width)
        while x <= maxPosition {
            let indexPath = IndexPath(item: itemIndex%self.numberOfItems, section: itemIndex/self.numberOfItems)
            let attributes = self.layoutAttributesForItem(at: indexPath)!
            self.applyTransform(to: attributes)
            layoutAttributes.append(attributes)
            itemIndex += 1
            x += self.itemSpan
        }
        return layoutAttributes
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else {
            return UICollectionViewLayoutAttributes(forCellWith: indexPath)
        }
        if let attributes = self.layoutAttributes[indexPath] {
            return attributes
        }
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let x = self.frame(for: indexPath).minX
        let center = CGPoint(x: x+self.actualItemSize.width*0.5, y: collectionView.frame.height*0.5)
        attributes.center = center
        attributes.size = self.actualItemSize
        self.layoutAttributes[indexPath] = attributes
        return attributes
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }
        var proposedContentOffset = proposedContentOffset
        let proposedContentOffsetX: CGFloat = {
            let translation = -collectionView.panGestureRecognizer.translation(in: collectionView).x
            var offset: CGFloat = round(proposedContentOffset.x/self.itemSpan)*self.itemSpan
            let minFlippingDistance = min(0.5 * self.itemSpan,150)
            let originalContentOffsetX = collectionView.contentOffset.x - translation
            if abs(translation) <= minFlippingDistance {
                if abs(velocity.x) >= 0.3 && abs(proposedContentOffset.x-originalContentOffsetX) <= self.itemSpan*0.5 {
                    offset += self.itemSpan * (velocity.x)/abs(velocity.x)
                }
            }
            return offset
        }()
        proposedContentOffset = CGPoint(x: proposedContentOffsetX, y: proposedContentOffset.y)
        return proposedContentOffset
    }
    
    // MARK:- Internal functions
    
    internal func forceInvalidate() {
        self.needsReprepare = true
        self.invalidateLayout()
    }
    
    internal func contentOffset(for indexPath: IndexPath) -> CGPoint {
        let origin = self.frame(for: indexPath).origin
        guard let collectionView = self.collectionView else {
            return origin
        }
        let contentOffset = CGPoint(x: origin.x - (collectionView.frame.width*0.5-self.actualItemSize.width*0.5), y: collectionView.contentOffset.y)
        return contentOffset
    }
    
    internal func frame(for indexPath: IndexPath) -> CGRect {
        let numberOfItems = self.numberOfItems*indexPath.section + indexPath.item
        let originX = self.leadingSpacing + CGFloat(numberOfItems)*self.itemSpan
        let originY = (self.collectionView!.frame.height-self.actualItemSize.height)
        let origin = CGPoint(x: originX, y: originY)
        let frame = CGRect(origin: origin, size: self.actualItemSize)
        return frame
    }
    
    // MARK:- Private functions
    
    fileprivate func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc
    fileprivate func didReceiveNotification(notification: Notification) {
        if self.pagerView?.itemSize == .zero {
            self.adjustCollectionViewBounds()
        }
    }
    
    fileprivate func adjustCollectionViewBounds() {
        guard let collectionView = self.collectionView, let pagerView = self.pagerView else {
            return
        }
        let currentIndex = pagerView.currentIndex
        let newIndexPath = IndexPath(item: currentIndex, section: self.isInfinite ? self.numberOfSections/2 : 0)
        let contentOffsetX = self.contentOffset(for: newIndexPath).x
        let contentOffset = CGPoint(x: contentOffsetX, y: 0)
        let newBounds = CGRect(origin: contentOffset, size: collectionView.frame.size)
        collectionView.bounds = newBounds
    }
    
    fileprivate func applyTransform(to attributes: UICollectionViewLayoutAttributes) {
        guard let collectionView = self.collectionView else {
            return
        }
        guard let transformer = self.pagerView?.transformer else {
            return
        }
        let ruler = collectionView.bounds.midX
        let position = (attributes.center.x-ruler)/self.itemSpan
        transformer.applyTransform(to: attributes, for: position)
    }

}


