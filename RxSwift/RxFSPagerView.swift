//
//  RxFSPagerView.swift
//  RxExtensions
//
//  Created by yangkejun on 2021/12/3.
//

@_exported import RxSwift
@_exported import RxCocoa

public extension Reactive where Base: FSPagerView {

    /**
    Binds sequences of elements to collection view items.

    - parameter cellIdentifier: Identifier used to dequeue cells.
    - parameter source: Observable sequence of items.
    - parameter configureCell: Transform between sequence elements and view cells.
    - returns: Disposable object that can be used to unbind.

     Example

         let items = Observable.just(["image1", "image2", "image3"])
         items.bind(to: pagerView.rx.items(cellIdentifier: "FSPagerViewCell")) { (row, element, cell) in
             cell.imageView?.image = UIImage(named: element)
         }.disposed(by: disposeBag)

    */
    func items<Sequence: Swift.Sequence, Cell: FSPagerViewCell, Source: ObservableType>
    (cellIdentifier: String? = String(describing: FSPagerViewCell.self))
    -> (_ source: Source)
    -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
    -> Disposable where Source.Element == Sequence {
        base.collectionView.dataSource = nil
        return { source in
            let type: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(queue: .global())
            let source = source.observe(on: type).map { sequence -> [Sequence.Element] in
                let datas = Array(sequence)
                guard datas.isEmpty == false else { return [] }
                base.numberOfItems = Int(Int16.max)
                base.numberOfSections = datas.count
                let loop = datas.count > 1 || base.removesInfiniteLoopForSingleItem == false
                let count = base.isInfinite && loop ? base.numberOfItems / datas.count : 1
                var array:[Sequence.Element] = []
                for _ in 0..<count { array += datas }
                return array
            }
            return base.collectionView.rx.items(cellIdentifier: cellIdentifier!, cellType: Cell.self)(source)
        }
    }
}

public extension Reactive where Base: FSPagerView {

    /// Reactive wrapper for `delegate` message `FSPagerView(_:didSelectItemAtIndex:)`.
    var didSelectItemAtIndex: ControlEvent<Int> {
        let source = base.collectionView.rx.itemSelected.flatMap { IndexPath in
            return Observable.just(IndexPath.row % base.numberOfSections)
        }
        return ControlEvent(events: source)
    }

    /// Reactive wrapper for `delegate` message `FSPagerView(pagerViewDidScroll:)`.
    var pagerViewDidScroll: ControlEvent<Int> {
        let source = base.collectionView.rx.didScroll.flatMap { () -> Observable<Int> in
            if base.numberOfItems > 0 {
                let currentIndex = lround(Double(base.scrollOffset)) % base.numberOfItems
                if (currentIndex != base.currentIndex) {
                    return Observable.just(currentIndex % base.numberOfSections)
                }
            }
            return Observable.never()
        }
        return ControlEvent(events: source)
    }
}
