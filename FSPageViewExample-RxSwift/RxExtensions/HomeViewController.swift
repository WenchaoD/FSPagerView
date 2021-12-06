//
//  HomeViewController.swift
//  RxExtensions
//
//  Created by yangkejun on 2021/12/3.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import FSPagerViewRxSwift

class HomeViewController: UIViewController {
 
    public let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupBinding()
    }
    
    lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView(frame: .zero)
        pagerView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 2
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        return pagerView
    }()
    
    lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl.init()
        return pageControl
    }()
    
    func setupUI() {
        self.title = "🎷 RxFSPagerView"
        self.view.addSubview(self.pagerView)
        self.view.addSubview(self.pageControl)
        let width = self.view.frame.size.width - 40
        self.pagerView.frame = CGRect(x: 20, y: 200, width: width, height: width * 0.5)
        self.pageControl.frame = CGRect(x: 20, y: 200 + width * 0.5 - 25, width: width, height: 20)
//        self.pagerView.snp.makeConstraints { make in
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
//            make.left.right.equalTo(self.view).inset(30)
//            make.height.equalTo(self.pagerView.snp.width).multipliedBy(0.5)
//        }
//        self.pageControl.snp.makeConstraints { make in
//            make.bottom.equalTo(self.pagerView.snp.bottom).inset(5)
//            make.left.right.equalTo(self.pagerView)
//            make.height.equalTo(20)
//        }
    }
    
    func setupBinding() {
        let datasObserver = Observable.just(["luoza", "nini", "xiong", "yu"])
        
        datasObserver.bind(to: pagerView.rx.items()) { (row, element, cell) in
            cell.imageView?.image = UIImage(named: element)
        }.disposed(by: disposeBag)
        
        datasObserver.map { $0.count }.bind(to: pageControl.rx.numberOfPages).disposed(by: disposeBag)
        
        pagerView.rx.didSelectItemAtIndex.subscribe(onNext: { index in
            debugPrint(index)
        }).disposed(by: disposeBag)
        
        pagerView.rx.pagerViewDidScroll.subscribe(onNext: { [weak self] index in
            self?.pageControl.currentPage = index
        }).disposed(by: disposeBag)
    }
}
