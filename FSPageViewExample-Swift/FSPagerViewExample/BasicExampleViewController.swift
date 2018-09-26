//
//  ViewController.swift
//  FSPagerViewExample
//
//  Created by Wenchao Ding on 17/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit

class BasicExampleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FSPagerViewDataSource,FSPagerViewDelegate {
    
    fileprivate let sectionTitles = ["Configurations", "Decelaration Distance", "Item Size", "Interitem Spacing", "Number Of Items"]
    fileprivate let configurationTitles = ["Automatic sliding","Infinite"]
    fileprivate let decelerationDistanceOptions = ["Automatic", "1", "2"]
    fileprivate let imageNames = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg"]
    fileprivate var numberOfItems = 7
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.numberOfPages = self.imageNames.count
            self.pageControl.contentHorizontalAlignment = .right
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.configurationTitles.count
        case 1:
            return self.decelerationDistanceOptions.count
        case 2,3,4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // Configurations
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = self.configurationTitles[indexPath.row]
            if indexPath.row == 0 {
                // Automatic Sliding
                cell.accessoryType = self.pagerView.automaticSlidingInterval > 0 ? .checkmark : .none
            } else if indexPath.row == 1 {
                // IsInfinite
                cell.accessoryType = self.pagerView.isInfinite ? .checkmark : .none
            }
            return cell
        case 1:
            // Decelaration Distance
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = self.decelerationDistanceOptions[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.accessoryType = self.pagerView.decelerationDistance == FSPagerView.automaticDistance ? .checkmark : .none
            case 1:
                cell.accessoryType = self.pagerView.decelerationDistance == 1 ? .checkmark : .none
            case 2:
                cell.accessoryType = self.pagerView.decelerationDistance == 2 ? .checkmark : .none
            default:
                break;
            }
            return cell;
        case 2:
            // Item Spacing
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider_cell")!
            let slider = cell.contentView.subviews.first as! UISlider
            slider.tag = 1
            slider.value = {
                let scale: CGFloat = self.pagerView.itemSize.width/self.pagerView.frame.width
                let value: CGFloat = (0.5-scale)*2
                return Float(value)
            }()
            slider.isContinuous = true
            return cell
        case 3:
            // Interitem Spacing
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider_cell")!
            let slider = cell.contentView.subviews.first as! UISlider
            slider.tag = 2
            slider.value = Float(self.pagerView.interitemSpacing/20.0)
            slider.isContinuous = true
            return cell
        case 4:
            // Number Of Items
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider_cell")!
            let slider = cell.contentView.subviews.first as! UISlider
            slider.tag = 3
            slider.minimumValue = 1.0 / 7
            slider.maximumValue = 1.0
            slider.value = Float(self.numberOfItems) / 7.0
            slider.isContinuous = false
            return cell
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 || indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 { // Automatic Sliding
                self.pagerView.automaticSlidingInterval = 3.0 - self.pagerView.automaticSlidingInterval
            } else if indexPath.row == 1 { // IsInfinite
                self.pagerView.isInfinite = !self.pagerView.isInfinite
            }
            tableView.reloadSections([indexPath.section], with: .automatic)
        case 1:
            switch indexPath.row {
            case 0:
                self.pagerView.decelerationDistance = FSPagerView.automaticDistance
            case 1:
                self.pagerView.decelerationDistance = 1
            case 2:
                self.pagerView.decelerationDistance = 2
            default:
                break
            }
            tableView.reloadSections([indexPath.section], with: .automatic)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 40 : 20
    }
    
    // MARK:- FSPagerView DataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.numberOfItems
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = index.description+index.description
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        switch sender.tag {
        case 1:
            let newScale = 0.5+CGFloat(sender.value)*0.5 // [0.5 - 1.0]
            self.pagerView.itemSize = self.pagerView.frame.size.applying(CGAffineTransform(scaleX: newScale, y: newScale))
        case 2:
            self.pagerView.interitemSpacing = CGFloat(sender.value) * 20 // [0 - 20]
        case 3:
            self.numberOfItems = Int(roundf(sender.value*7.0))
            self.pageControl.numberOfPages = self.numberOfItems
            self.pagerView.reloadData()
        default:
            break
        }
    }
}


