![fspagerview](https://cloud.githubusercontent.com/assets/5186464/24086370/45e7e8dc-0d49-11e7-86aa-139354fe00c5.jpg)

[![Languages](https://img.shields.io/badge/language-swift%204.2%20|%20objc-FF69B4.svg?style=plastic)](#) <br/>
[![Platform](https://img.shields.io/badge/platform-iOS%20|%20tvOS-blue.svg?style=plastic)](http://cocoadocs.org/docsets/FSPagerView)
[![Version](https://img.shields.io/cocoapods/v/FSPagerView.svg?style=plastic)](http://cocoadocs.org/docsets/FSPagerView) 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=plastic)](https://github.com/Carthage/Carthage)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-FF9966.svg?style=plastic)](https://swift.org/package-manager/)

|<b>SWIFT</b>|[<b>OBJECTIVE-C</b>](https://github.com/WenchaoD/FSPagerView/blob/master/README-OBJECTIVE-C.md) |
|---|---|

**FSPagerView** is an elegant Screen Slide Library implemented primarily with ***UICollectionView***. It is extremely helpful for making Banner、Product Show、Welcome/Guide Pages、Screen/ViewController Sliders.

## Features
*  ***Infinite*** scrolling.
*  ***Automatic*** Sliding.
*  ***Horizontal*** and ***Vertical*** paging.
*  Fully customizable item, with predefined banner-style item.
*  Fully customizable ***page control***.
*  Rich build-in 3D transformers.
*  ***Simple*** and ***Delightful*** api usage.
*  Support **SWIFT** and **OBJECTIVE-C**.

## Demos
* [Demo1 - Banner](#banner)
* [Demo2 - Transformer](#transformer)
* [Demo3 - Page Control](#page_control)

### Demo1 - Banner <a id="banner"></a>

| Banner |
|---|
|![9](https://cloud.githubusercontent.com/assets/5186464/22688057/9003d880-ed65-11e6-882e-4587c97c8878.gif) |

### automaticSlidingInterval
The time interval of automatic sliding. 0 means disabling automatic sliding. Default is 0.

**e.g.**

```swift
pagerView.automaticSlidingInterval = 3.0
```


### isInfinite
A boolean value indicates whether the pager view has infinite number of items. Default is false.

**e.g.**

```swift
pagerView.isInfinite = true
```

### decelerationDistance
An unsigned integer value that determines the paging distance of the pager view, which indicates the number of passing items during the deceleration. When the value of this property is FSPagerView.automaticDistance, the actual 'distance' is automatically calculated according to the scrolling speed of the pager view. Default is 1.

**e.g.**

```swift
pagerView.decelerationDistance = 2
```

### itemSize
The item size of the pager view. When the value of this property is FSPagerView.automaticSize, the items fill the entire visible area of the pager view. Default is FSPagerView.automaticSize.

**e.g.**

```swift
pagerView.itemSize = CGSize(width: 200, height: 180)
```

### interitemSpacing
The spacing to use between items in the pager view. Default is 0.

**e.g.**

```swift
pagerView.interitemSpacing = 10
```

## Demo2 - Transformers

|Cross Fading|
|---|
| ![1](https://cloud.githubusercontent.com/assets/5186464/22686429/1983b97e-ed5f-11e6-9a32-44c1830df7ac.gif) |

```swift
pagerView.transformer = FSPagerViewTransformer(type: .crossfading)
```
---



|Zoom Out|
|---|
| ![2](https://cloud.githubusercontent.com/assets/5186464/22686426/19830862-ed5f-11e6-90be-8fb1319cd125.gif) |

```swift
pagerView.transformer = FSPagerViewTransformer(type: .zoomout)
```
---


|Depth|
|---|
| ![3](https://cloud.githubusercontent.com/assets/5186464/22686430/19856c1a-ed5f-11e6-8187-9e4395b7597c.gif) |

```swift
pagerView.transformer = FSPagerViewTransformer(type: .depth)
```
---


|Linear|
|---|
| ![4](https://cloud.githubusercontent.com/assets/5186464/22686428/198368c0-ed5f-11e6-95df-cfcfe9bc3f29.gif) |

```swift
pagerView.transformer = FSPagerViewTransformer(type: .linear)
```
---


|Overlap|
|---|
| ![5](https://cloud.githubusercontent.com/assets/5186464/22686431/198905aa-ed5f-11e6-9312-ec371c8c4e44.gif) |

```swift
pagerView.transformer = FSPagerViewTransformer(type: .overlap)
```
---


|Ferris Wheel|
|------|
| ![6](https://cloud.githubusercontent.com/assets/5186464/22686427/19831c08-ed5f-11e6-8bdb-30e762a85d4b.gif) |

```swift
pagerView.transformer = FSPagerViewTransformer(type: .ferrisWheel)
```
---


|Inverted Ferris Wheel|
|------|
| ![7](https://cloud.githubusercontent.com/assets/5186464/22686433/19b669a0-ed5f-11e6-8bf0-dc23edf8101f.gif) |

```swift
pagerView.transformer = FSPagerViewTransformer(type: .invertedFerrisWheel)
```
---


|Cover Flow|
|------|
| ![8](https://cloud.githubusercontent.com/assets/5186464/22686432/19b567f8-ed5f-11e6-885d-bd660c98b507.gif) |
```swift
pagerView.transformer = FSPagerViewTransformer(type: .coverFlow)
```
---

|Cubic|
|------|
| ![9](https://cloud.githubusercontent.com/assets/5186464/23461598/8875080c-fec5-11e6-8db6-6d8864acfcc1.gif) |
```swift
pagerView.transformer = FSPagerViewTransformer(type: .cubic)
```
---



> Customize your own transformer by subclassing`FSPagerViewTransformer.`


## Demo3 Page Control
|Page Control|
|---|
|![10](https://cloud.githubusercontent.com/assets/5186464/22689720/2baabdb0-ed6d-11e6-8287-ef7a2c0f64bc.gif)
|

### numberOfPages
The number of page indicators of the page control. Default is 0.

**e.g.**

```swift
pageControl.numberOfPages = 5
```

### currentPage
The current page, highlighted by the page control. Default is 0.

**e.g.**

```swift
pageControl.currentPage = 1
```

### contentHorizontalAlignment
The horizontal alignment of content within the control’s bounds. Default is center.

**e.g.**
```swift
pageControl.contentHorizontalAlignment = .right
```

### setStrokeColor:forState:
Sets the stroke color for page indicators to use for the specified state. (selected/normal).

**e.g.**

```swift
pageControl.setStrokeColor(.green, for: .normal)
pageControl.setStrokeColor(.yellow, for: .selected)
```


### setFillColor:forState:
Sets the fill color for page indicators to use for the specified state. (selected/normal).

**e.g.**

```swift
pageControl.setFillColor(.gray, for: .normal)
pageControl.setFillColor(.white, for: .selected)
```

### setImage:forState:
Sets the image for page indicators to use for the specified state. (selected/normal).

**e.g.**

```swift
pageControl.setImage(UIImage(named:"image1"), for: .normal)
pageControl.setImage(UIImage(named:"image2"), for: .selected)
```

### setPath:forState:
Sets the path for page indicators to use for the specified state. (selected/normal).

**e.g.**

```swift
pageControl.setPath(UIBezierPath(rect: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .normal)
pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .selected)
```

## Installation
* Manually
* Cocoapods
* Carthage

### Manually
1. ***[Download](#)*** the source code.
2. Extract the zip file, simply drag folder ***Sources*** into your project.
3. Make sure ***Copy items if needed*** is checked.

### Cocoapods
```ruby
use_frameworks!
target '<Your Target Name>' do
    pod 'FSPagerView'
end
```

### Carthage
```ruby
github "WenchaoD/FSPagerView"
```

## Tutorial
* [Getting started](#getting_started)
* [Implement FSPagerViewDataSource](#implement_fspagerviewdatasource)
* [Implement FSPagerViewDelegate](#implement_fspagerviewdelegate)

### 1. Getting started <a id='getting_started'></a>

* Getting started with code

```swift
// Create a pager view
let pagerView = FSPagerView(frame: frame1)
pagerView.dataSource = self
pagerView.delegate = self
pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
self.view.addSubview(pagerView)
// Create a page control
let pageControl = FSPageControl(frame: frame2)
self.view.addSubview(pageControl)
```

* Getting started with Interface Builder <br/>
1、Simply drag **UIView** instance into your View Controller, Change the `Custom Class` to `FSPagerView`. (Or `FSPageControl`) <br/>
2、Link the `dataSource` and `delegate` property of **FSPagerView** to your View Controller. <br/>
3、Register a cell class.

```swift
@IBOutlet weak var pagerView: FSPagerView! {
    didSet {
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}
```


### 2. Implement FSPagerViewDataSource <a id='implement_fspagerviewdatasource'></a>
```swift
public func numberOfItems(in pagerView: FSPagerView) -> Int {
    return numberOfItems
}
    
public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
    cell.imageView?.image = ...
    cell.textLabel?.text = ...
    return cell
}
```

### 3. Implement FSPagerViewDelegate <a id='implement_fspagerviewdelegate'></a>

```swift
func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool
```
> Asks the delegate if the item should be highlighted during tracking.

---

```swift
func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int)
```
> Tells the delegate that the item at the specified index was highlighted.
    
---
    
```swift
func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool
```
> Asks the delegate if the specified item should be selected.
    
---
    
```swift
func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int)
```
> Tells the delegate that the item at the specified index was selected.
    
---
    
```swift
func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int)
```
> Tells the delegate that the specified cell is about to be displayed in the pager view.
    
---
    
```swift
func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int)
```
> Tells the delegate that the specified cell was removed from the pager view.
    
---
    
```swift
func pagerViewWillBeginDragging(_ pagerView: FSPagerView)
```
> Tells the delegate when the pager view is about to start scrolling the content.
    
---
    
```swift
func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int)
```
> Tells the delegate when the user finishes scrolling the content.
    
---
    
```swift
func pagerViewDidScroll(_ pagerView: FSPagerView)
```
> Tells the delegate when the user scrolls the content view within the receiver.
    
---
    
```swift
func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView)
```
> Tells the delegate when a scrolling animation in the pager view concludes.
    
---
    
```swift
func pagerViewDidEndDecelerating(_ pagerView: FSPagerView)
```
> Tells the delegate that the pager view has ended decelerating the scrolling movement.

---

## <a id="support"></a>Support this repo
* ***Star*** this repo <a href="#"><img style="margin-bottom:-12px" width="72" alt="star" src="https://cloud.githubusercontent.com/assets/5186464/15383105/fcf9cdf0-1dc2-11e6-88db-bf221042a584.png"></a>
<br/>

* Buy me a Coffee. ☕️ 
   
   <a href="https://www.paypal.me/WenchaoD" target="_blank"><img src="https://www.paypalobjects.com/webstatic/i/logo/rebrand/ppcom.svg" width="100" height="40" style="margin-bottom:-15px;"></a> &nbsp;&nbsp;|&nbsp;&nbsp;
	<a href="https://user-images.githubusercontent.com/5186464/45949944-46960480-c030-11e8-9e90-30b015698cf6.png" target="_blank"><img src="http://a1.mzstatic.com/us/r30/Purple49/v4/50/16/b3/5016b341-39c1-b47b-2994-d7e23823baed/icon175x175.png" width="40" height="40" style="margin-bottom:-15px;-webkit-border-radius:10px;border:1px solid rgba(30, 154, 236, 1);"></a> &nbsp;&nbsp;|&nbsp;&nbsp;
	<a href="https://cloud.githubusercontent.com/assets/5186464/15096872/b06f3a3a-153c-11e6-89f9-2e9c7b88ef42.png" target="_blank"><img src="http://a4.mzstatic.com/us/r30/Purple49/v4/23/31/14/233114f8-2e8d-7b63-8dc5-85d29893061e/icon175x175.jpeg" height="40" width="40" style="margin-bottom:-15px; -webkit-border-radius: 10px;border:1px solid rgba(43, 177, 0, 1)"></a>

--- 
	
	
## Author
* ***微博：[@WenchaoD](http://weibo.com/WenchaoD)***
* ***Twitter: [@WenchaoD](https://twitter.com/WenchaoD)***
* Other repos: 
	* [***FSCalendar***](https://github.com/WenchaoD)

---

# [Documentation](http://cocoadocs.org/docsets/FSPagerView)