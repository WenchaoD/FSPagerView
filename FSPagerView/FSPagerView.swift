//
//  FSPagerView.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 17/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit

@objc
public protocol FSPagerViewTransitionAnimatior: NSObjectProtocol {
    /// Customize your switching animation
    @objc(applyTransformToAttributes:forPosition: itemSpan:)
    func applyTransform(to attributes: UICollectionViewLayoutAttributes,
                        for position: CGFloat,
                        and itemSpan: CGFloat)
    
    /// Get proposed interitem spacing percent
    @objc
    func proposedInteritemSpacingPercent() -> CGFloat
}

@objc
public protocol FSPagerViewDataSource: NSObjectProtocol {
    
    /// Asks your data source object for the number of items in the pager view.
    @objc(numberOfItemsInpagerView:)
    func numberOfItems(in pagerView: FSPagerView) -> Int
    
    /// Asks your data source object for the cell that corresponds to the specified item in the pager view.
    @objc(pagerView:cellForItemAtIndex:)
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell
    
}

@objc
public protocol FSPagerViewDelegate: NSObjectProtocol {
    
    /// Asks the delegate if the item should be highlighted during tracking.
    @objc(pagerView:shouldHighlightItemAtIndex:)
    optional func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool
    
    /// Tells the delegate that the item at the specified index was highlighted.
    @objc(pagerView:didHighlightItemAtIndex:)
    optional func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int)
    
    /// Asks the delegate if the specified item should be selected.
    @objc(pagerView:shouldSelectItemAtIndex:)
    optional func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool
    
    /// Tells the delegate that the item at the specified index was selected.
    @objc(pagerView:didSelectItemAtIndex:)
    optional func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int)
    
    /// Tells the delegate that the specified cell is about to be displayed in the pager view.
    @objc(pagerView:willDisplayCell:forItemAtIndex:)
    optional func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int)
    
    /// Tells the delegate that the specified cell was removed from the pager view.
    @objc(pagerView:didEndDisplayingCell:forItemAtIndex:)
    optional func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int)
    
    /// Tells the delegate when the pager view is about to start scrolling the content.
    @objc(pagerViewWillBeginDragging:)
    optional func pagerViewWillBeginDragging(_ pagerView: FSPagerView)
    
    /// Tells the delegate when the user finishes scrolling the content.
    @objc(pagerViewWillEndDragging:targetIndex:)
    optional func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int)
    
    /// Tells the delegate when the user scrolls the content view within the receiver.
    @objc(pagerViewDidScroll:)
    optional func pagerViewDidScroll(_ pagerView: FSPagerView)
    
    /// Tells the delegate when a scrolling animation in the pager view concludes.
    @objc(pagerViewDidEndScrollAnimation:)
    optional func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView)
    
    /// Tells the delegate that the pager view has ended decelerating the scrolling movement.
    @objc(pagerViewDidEndDecelerating:)
    optional func pagerViewDidEndDecelerating(_ pagerView: FSPagerView)
    
}

@IBDesignable
open class FSPagerView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    
    // MARK: - Public properties
    
    #if TARGET_INTERFACE_BUILDER
    // Yes you need to lie to the Interface Builder, otherwise "@IBOutlet" cannot be connected.
    @IBOutlet open weak var dataSource: AnyObject?
    @IBOutlet open weak var delegate: AnyObject?
    #else
    open weak var dataSource: FSPagerViewDataSource?
    open weak var delegate: FSPagerViewDelegate?
    #endif

    /// The time interval of automatic sliding. 0 means disabling automatic sliding. Default is 0.
    @IBInspectable
    open var automaticSlidingInterval: CGFloat = 0.0 {
        didSet {
            self.cancelTimer()
            if self.automaticSlidingInterval > 0 {
                self.startTimer()
            }
        }
    }
    
    /// The spacing to use between items in the pager view. Default is 0.
    @IBInspectable
    open var interitemSpacing: CGFloat = 0 {
        didSet {
            self.collectionViewLayout.forceInvalidate()
        }
    }
    
    /// The item size of the pager view. .zero means always fill the bounds of the pager view. Default is .zero.
    @IBInspectable
    open var itemSize: CGSize = .zero {
        didSet {
            self.collectionViewLayout.forceInvalidate()
        }
    }
    
    
    /// A Boolean value indicates that whether the pager view has infinite items. Default is false.
    @IBInspectable
    open var isInfinite: Bool = false {
        didSet {
            self.collectionView.reloadData()
            self.collectionViewLayout.forceInvalidate()
        }
    }
    
    
    /// The background view of the pager view
    @IBInspectable
    open var backgroundView: UIView? {
        didSet {
            if let backgroundView = self.backgroundView {
                if backgroundView.superview != nil {
                    backgroundView.removeFromSuperview()
                }
                self.insertSubview(backgroundView, at: 0)
                self.setNeedsLayout()
            }
        }
    }
    
    /// The transformer of the pager view
    open var transformer: FSPagerViewTransitionAnimatior? {
        didSet {
            self.collectionViewLayout.forceInvalidate()
        }
    }
    
    /// Returns whether the user has touched the content to initiate scrolling.
    open var isTracking: Bool {
        return self.collectionView.isTracking
    }
    
    // MARK: - Public readonly-properties
    
    open fileprivate(set) dynamic var currentIndex: Int = 0
    
    // MARK: - Private properties
    
    internal weak var collectionViewLayout: FSPagerViewLayout!
    internal weak var collectionView: FSPagerViewCollectionView!
    internal weak var contentView: UIView!
    
    internal var timer: Timer?
    internal var numberOfItems: Int = 0
    internal var numberOfSections: Int = 0
    
    fileprivate var dequeingSection = 0
    fileprivate var centermostIndexPath: IndexPath {
        guard self.numberOfItems > 0, self.collectionView.contentSize.width > 0 else {
            return IndexPath(item: 0, section: 0)
        }
        let sortedIndexPaths = self.collectionView.indexPathsForVisibleItems.sorted { (l, r) -> Bool in
            let leftCenter = self.collectionViewLayout.frame(for: l).midX
            let rightCenter = self.collectionViewLayout.frame(for: r).midX
            let ruler = self.collectionView.bounds.midX
            return abs(ruler-leftCenter) < abs(ruler-rightCenter)
        }
        let indexPath = sortedIndexPaths.first
        if let indexPath = indexPath {
            return indexPath
        }
        return IndexPath(item: 0, section: 0)
    }
    
    fileprivate var possibleTargetingIndexPath: IndexPath?

    
    // MARK: - Overriden functions
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds
        self.contentView.frame = self.bounds
        self.collectionView.frame = self.contentView.bounds
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            self.startTimer()
        } else {
            self.cancelTimer()
        }
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
        let label = UILabel(frame: self.contentView.bounds)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "FSPagerView"
        self.contentView.addSubview(label)
    }
    
    deinit {
        self.collectionView.dataSource = nil
        self.collectionView.delegate = nil
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let dataSource = self.dataSource else {
            return 1
        }
        self.numberOfItems = dataSource.numberOfItems(in: self)
        self.numberOfSections = self.isInfinite ? Int(Int16.max)/self.numberOfItems : 1
        return self.numberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        self.dequeingSection = indexPath.section
        let cell = self.dataSource!.pagerView(self, cellForItemAt: index)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let function = self.delegate?.pagerView(_:shouldHighlightItemAt:) else {
            return true
        }
        let index = indexPath.item % self.numberOfItems
        return function(self,index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let function = self.delegate?.pagerView(_:didHighlightItemAt:) else {
            return
        }
        let index = indexPath.item % self.numberOfItems
        function(self,index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let function = self.delegate?.pagerView(_:shouldSelectItemAt:) else {
            return true
        }
        let index = indexPath.item % self.numberOfItems
        return function(self,index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let function = self.delegate?.pagerView(_:didSelectItemAt:) else {
            return
        }
        self.possibleTargetingIndexPath = indexPath
        defer {
            self.possibleTargetingIndexPath = nil
        }
        let index = indexPath.item % self.numberOfItems
        function(self,index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let function = self.delegate?.pagerView(_:willDisplay:forItemAt:) else {
            return
        }
        let index = indexPath.item % self.numberOfItems
        function(self,cell as! FSPagerViewCell,index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let function = self.delegate?.pagerView(_:didEndDisplaying:forItemAt:) else {
            return
        }
        let index = indexPath.item % self.numberOfItems
        function(self,cell as! FSPagerViewCell,index)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.numberOfItems > 0 {
            // In case someone is using KVO
            let currentIndex = lround(Double(scrollView.contentOffset.x.divided(by: self.collectionViewLayout.itemSpan))) % self.numberOfItems
            if (currentIndex != self.currentIndex) {
                self.currentIndex = currentIndex
            }
        }
        guard let function = self.delegate?.pagerViewDidScroll else {
            return
        }
        function(self)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let function = self.delegate?.pagerViewWillBeginDragging(_:) {
            function(self)
        }
        if self.automaticSlidingInterval > 0 {
            self.cancelTimer()
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let function = self.delegate?.pagerViewWillEndDragging(_:targetIndex:) {
            let targetItem = lround(Double(targetContentOffset.pointee.x/self.collectionViewLayout.itemSpan))
            function(self, targetItem % self.numberOfItems)
        }
        if self.automaticSlidingInterval > 0 {
            self.startTimer()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let function = self.delegate?.pagerViewDidEndDecelerating {
            function(self)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let function = self.delegate?.pagerViewDidEndScrollAnimation {
            function(self)
        }
    }
    
    // MARK: - Public functions
    
    @objc(registerClass:forCellWithReuseIdentifier:)
    open func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        guard let cellClass = cellClass, cellClass.isSubclass(of: FSPagerViewCell.self) else {
            fatalError("Cell class must be subclass of FSPagerViewCell")
        }
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    @objc(dequeueReusableCellWithReuseIdentifier:atIndex:)
    open func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> FSPagerViewCell {
        let indexPath = IndexPath(item: index, section: self.dequeingSection)
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FSPagerViewCell
        return cell
    }
    
    @objc(reloadData)
    open func reloadData() {
        self.collectionView.reloadData()
    }
    
    @objc(selectItemAtIndex:animated:)
    open func selectItem(at index: Int, animated: Bool) {
        let indexPath = self.nearbyIndexPath(for: index)
        self.collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: .centeredHorizontally)
    }
    
    @objc(deselectItemAtIndex:animated:)
    open func deselectItem(at index: Int, animated: Bool) {
        let indexPath = self.nearbyIndexPath(for: index)
        self.collectionView.deselectItem(at: indexPath, animated: animated)
    }
    
    @objc(scrollToItemAtIndex:animated:)
    open func scrollToItem(at index: Int, animated: Bool) {
        guard index < self.numberOfItems else {
            fatalError("index \(index) is out of range [0...\(self.numberOfItems-1)]")
        }
        let indexPath = { () -> IndexPath in
            if let indexPath = self.possibleTargetingIndexPath, indexPath.item == index {
                defer {
                    self.possibleTargetingIndexPath = nil
                }
                return indexPath
            }
            return self.isInfinite ? self.nearbyIndexPath(for: index) : IndexPath(item: index, section: 0)
        }()
        let contentOffset = self.collectionViewLayout.contentOffset(for: indexPath)
        self.collectionView.setContentOffset(contentOffset, animated: animated)
    }
    
    // MARK: - Private functions
    
    fileprivate func commonInit() {
        
        // Content View
        let contentView = UIView(frame:CGRect.zero)
        contentView.backgroundColor = UIColor.clear
        self.addSubview(contentView)
        self.contentView = contentView
        
        // UICollectionView
        let collectionViewLayout = FSPagerViewLayout()
        let collectionView = FSPagerViewCollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        self.contentView.addSubview(collectionView)
        self.collectionView = collectionView
        self.collectionViewLayout = collectionViewLayout
        
    }
    
    fileprivate func startTimer() {
        guard self.automaticSlidingInterval > 0 && self.timer == nil else {
            return
        }
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.automaticSlidingInterval), target: self, selector: #selector(self.flipNext(sender:)), userInfo: nil, repeats: true)
    }
    
    @objc
    fileprivate func flipNext(sender: Timer?) {
        guard let _ = self.superview, let _ = self.window else {
            return
        }
        guard !self.collectionView.isTracking else {
            return
        }
        self.scrollToItem(at: (self.currentIndex+1)%self.numberOfItems, animated: true)
    }
    
    fileprivate func cancelTimer() {
        guard self.timer != nil else {
            return
        }
        self.timer!.invalidate()
        self.timer = nil
    }
    
    fileprivate func nearbyIndexPath(for index: Int) -> IndexPath {
        // Is there a better algorithm?
        let currentIndex = self.currentIndex
        let currentSection = self.centermostIndexPath.section
        if abs(currentIndex-index) <= self.numberOfItems/2 {
            return IndexPath(item: index, section: currentSection)
        } else if (index-currentIndex >= 0) {
            return IndexPath(item: index, section: currentSection-1)
        } else {
            return IndexPath(item: index, section: currentSection+1)
        }
    }
    
}


