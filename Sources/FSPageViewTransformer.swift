//
//  FSPagerViewTransformer.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 05/01/2017.
//  Copyright © 2017 Wenchao Ding. All rights reserved.
//

import UIKit

@objc
public enum FSPagerViewTransformerType: Int {
    case none
    case crossFading
    case zoomOut
    case depth
    case overlap
    case linear
    case coverFlow
    case ferrisWheel
    case invertedFerrisWheel
    case cubic
}

open class FSPagerViewTransformer: NSObject {
    
    open internal(set) weak var pagerView: FSPagerView?
    open internal(set) var type: FSPagerViewTransformerType = .none
    
    open var minimumScale: CGFloat = 0.65
    open var minimumAlpha: CGFloat = 0.6
    
    public init(type: FSPagerViewTransformerType) {
        super.init()
        self.type = type
        switch type {
        case .zoomOut:
            self.minimumScale = 0.85
        case .depth:
            self.minimumScale = 0.5
        default:
            break
        }
    }
    
    public override init () {
        super.init()
    }
    
    // Apply transform to attributes - zIndex: Int, frame: CGRect, alpha: CGFloat, transform: CGAffineTransform or transform3D: CATransform3D.
    open func applyTransform(to attributes: FSPagerViewLayoutAttributes) {
        let position = attributes.position
        let itemSpacing = attributes.interitemSpacing + attributes.bounds.width
        switch self.type {
        case .none:
            break
        case .crossFading:
            var zIndex = 0
            var alpha: CGFloat = 0
            let transform = CGAffineTransform(translationX: -itemSpacing * position, y: 0)
            if (abs(position) < 1) { // [-1,1]
                // Use the default slide transition when moving to the left page
                alpha = 1 - abs(position)
                zIndex = 1
            } else { // (1,+Infinity]
                // This page is way off-screen to the right.
                alpha = 0
                zIndex = Int.min
            }
            attributes.alpha = alpha
            attributes.transform = transform
            attributes.zIndex = zIndex
        case .zoomOut:
            var alpha: CGFloat = 0
            var transform = CGAffineTransform.identity
            switch position {
            case -CGFloat.greatestFiniteMagnitude ..< -1 : // [-Infinity,-1)
                // This page is way off-screen to the left.
                alpha = 0
            case -1 ... 1 :  // [-1,1]
                // Modify the default slide transition to shrink the page as well
                let scaleFactor = max(self.minimumScale, 1 - abs(position))
                let vertMargin = attributes.bounds.height * (1 - scaleFactor) / 2;
                let horzMargin = itemSpacing * (1 - scaleFactor) / 2;
                transform.a = scaleFactor
                transform.d = scaleFactor
                transform.tx = position < 0 ? (horzMargin - vertMargin*2) : (-horzMargin + vertMargin*2)
                // Fade the page relative to its size.
                alpha = self.minimumAlpha + (scaleFactor-self.minimumScale)/(1-self.minimumScale)*(1-self.minimumAlpha)
            case 1 ... CGFloat.greatestFiniteMagnitude :  // (1,+Infinity]
                // This page is way off-screen to the right.
                alpha = 0
            default:
                break
            }
            attributes.alpha = alpha
            attributes.transform = transform
        case .depth:
            var transform = CGAffineTransform.identity
            var zIndex = 0
            var alpha: CGFloat = 0.0
            switch position {
            case -CGFloat.greatestFiniteMagnitude ..< -1: // [-Infinity,-1)
                // This page is way off-screen to the left.
                alpha = 0
                zIndex = 0
            case -1 ... 0:  // [-1,0]
                // Use the default slide transition when moving to the left page
                alpha = 1
                transform.tx = 0
                transform.a = 1
                transform.d = 1
                zIndex = 1
            case 0 ..< 1: // (0,1]
                // Fade the page out.
                alpha = CGFloat(1.0) - position
                // Counteract the default slide transition
                transform.tx = itemSpacing * -position;
                // Scale the page down (between minimumScale and 1)
                let scaleFactor = self.minimumScale
                    + (1.0 - self.minimumScale) * (1.0 - abs(position));
                transform.a = scaleFactor
                transform.d = scaleFactor
                zIndex = 0
            case 1 ... CGFloat.greatestFiniteMagnitude: // (1,+Infinity]
                // This page is way off-screen to the right.
                alpha = 0
                zIndex = 0
            default:
                break
            }
            attributes.alpha = alpha
            attributes.transform = transform
            attributes.zIndex = zIndex
        case .overlap,.linear:
            let scale = max(1 - (1-self.minimumScale) * abs(position), self.minimumScale)
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            attributes.transform = transform
            let alpha = (self.minimumAlpha + (1-abs(position))*(1-self.minimumAlpha))
            attributes.alpha = alpha
            let zIndex = (1-abs(position)) * 10
            attributes.zIndex = Int(zIndex)
        case .coverFlow:
            let position = min(max(-position,-1) ,1)
            let rotation = sin(position*CGFloat(M_PI_2)) * CGFloat(M_PI_4)*1.5
            let translationZ = -itemSpacing * 0.5 * abs(position)
            var transform3D = CATransform3DIdentity
            transform3D.m34 = -0.002
            transform3D = CATransform3DRotate(transform3D, rotation, 0, 1, 0)
            transform3D = CATransform3DTranslate(transform3D, 0, 0, translationZ)
            attributes.zIndex = 100 - Int(abs(position))
            attributes.transform3D = transform3D
        case .ferrisWheel, .invertedFerrisWheel:
            // http://ronnqvi.st/translate-rotate-translate/
            var zIndex = 0
            var transform = CGAffineTransform.identity
            switch position {
            case -5 ... 5:
                let itemSpacing = attributes.bounds.width+self.proposedInteritemSpacing()
                let count: CGFloat = 14
                let circle: CGFloat = CGFloat(M_PI) * 2.0
                let radius = itemSpacing * count / circle
                let ty = radius * (self.type == .ferrisWheel ? 1 : -1)
                let theta = circle / count
                let rotation = position * theta * (self.type == .ferrisWheel ? 1 : -1)
                transform = transform.translatedBy(x: -position*itemSpacing, y: ty)
                transform = transform.rotated(by: rotation)
                transform = transform.translatedBy(x: 0, y: -ty)
                zIndex = Int((4.0-abs(position)*10))
            default:
                break
            }
            attributes.alpha = abs(position) < 0.5 ? 1 : self.minimumAlpha
            attributes.transform = transform
            attributes.zIndex = zIndex
        case .cubic:
            switch position {
            case -1...1:
                attributes.alpha = 1
                attributes.zIndex = Int((1-position) * CGFloat(10))
                let direction: CGFloat = position < 0 ? 1 : -1
                let theta = position * CGFloat(M_PI_2)
                let width = attributes.bounds.width
                // ForwardX -> RotateY -> BackwardX
                attributes.center.x += direction*width*0.5 // ForwardX
                var transform3D = CATransform3DIdentity
                transform3D.m34 = -0.002
                transform3D = CATransform3DRotate(transform3D, theta, 0, 1, 0) // RotateY
                transform3D = CATransform3DTranslate(transform3D,-direction*width*0.5, 0, 0) // BackwardX
                attributes.transform3D = transform3D
            default:
                attributes.zIndex = 0
                attributes.alpha = 0
            }
        }
    }
    
    // An interitem spacing proposed by transformer class. This will override the default interitemSpacing provided by the pager view.
    open func proposedInteritemSpacing() -> CGFloat {
        guard let pagerView = self.pagerView else {
            return 0
        }
        switch self.type {
        case .overlap:
            return pagerView.itemSize.width * -self.minimumScale * 0.6
        case .linear:
            return pagerView.itemSize.width * -self.minimumScale * 0.2
        case .coverFlow:
            return -pagerView.itemSize.width * sin(CGFloat(M_PI_4)/4.0*3.0)
        case .ferrisWheel,.invertedFerrisWheel:
            return -pagerView.itemSize.width * 0.15
        case .cubic:
            return 0
        default:
            break
        }
        return pagerView.interitemSpacing
    }
    
}

