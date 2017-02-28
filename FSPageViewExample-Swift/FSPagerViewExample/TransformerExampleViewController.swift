//
//  TransformerExampleViewController.swift
//  FSPagerViewExample
//
//  Created by Wenchao Ding on 09/01/2017.
//  Copyright © 2017 Wenchao Ding. All rights reserved.
//

import UIKit

class TransformerExampleViewController: UIViewController,FSPagerViewDataSource,FSPagerViewDelegate, UITableViewDataSource,UITableViewDelegate {
    
    fileprivate let imageNames = ["1_1.jpg","1_2.jpg","1_3.jpg","1_4.jpg","1_5.jpg","1_6.jpg","1_7.jpg"]
    fileprivate let transformerNames = ["cross fading", "zoom out", "depth", "linear", "overlap", "ferris wheel", "inverted ferris wheel", "coverflow", "cubic"]
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.crossFading,
                                                                      .zoomOut,
                                                                      .depth,
                                                                      .linear,
                                                                      .overlap,
                                                                      .ferrisWheel,
                                                                      .invertedFerrisWheel,
                                                                      .coverFlow,
                                                                      .cubic]
    fileprivate var typeIndex = 0 {
        didSet {
            let type = self.transformerTypes[typeIndex]
            self.pagerView.transformer = FSPagerViewTransformer(type:type)
            switch type {
            case .none, .crossFading, .zoomOut, .depth:
                self.pagerView.itemSize = .zero // 'Zero' means fill the size of parent
            case .linear, .overlap:
                let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
                self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
            case .ferrisWheel, .invertedFerrisWheel:
                self.pagerView.itemSize = CGSize(width: 180, height: 140)
            case .coverFlow:
                self.pagerView.itemSize = CGSize(width: 220, height: 170)
            case .cubic:
                let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.typeIndex = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let index = self.typeIndex
        self.typeIndex = index // Manually trigger didSet
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transformerNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.transformerNames[indexPath.row]
        cell.accessoryType = indexPath.row == self.typeIndex ? .checkmark : .none
        return cell
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.typeIndex = indexPath.row
        if let visibleRows = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: visibleRows, with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Transformers"
    }
    
    // MARK:- FSPagerViewDataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
}


