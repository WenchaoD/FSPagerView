//
//  RxFSPageControl.swift
//  RxExtensions
//
//  Created by yangkejun on 2021/12/3.
//

@_exported import RxSwift

public extension Reactive where Base: FSPageControl {
    
    var numberOfPages: Binder<Int> {
        return Binder(self.base) { PageControl, numberOfPages in
            PageControl.numberOfPages = numberOfPages
        }
    }
    
    var currentPage: Binder<Int> {
        return Binder(base) { PageControl, currentPage in
            PageControl.currentPage = currentPage
        }
    }
}
