//
//  FSPagerViewCell.swift
//  FSPagerView
//
//  Created by Wenchao Ding on 17/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit

open class FSPagerViewCell: UICollectionViewCell {

    /// Returns the label used for the main textual content of the pager view cell.
    @objc
    open var textLabel: UILabel? {
        if let _ = _textLabel {
            return _textLabel
        }
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        let textLabel = UILabel(frame: .zero)
        textLabel.textColor = .white
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.contentView.addSubview(view)
        textLabel.numberOfLines = 0
        view.addSubview(textLabel)

        textLabel.addObserver(self, forKeyPath: "font", options: [.old,.new], context: kvoContext)

        _textLabel = textLabel
        return textLabel
    }
    open var customTextLabelFrame: CGRect? = nil

    @objc
    open var subtextLabel: UILabel? {
        if let _ = _subtextLabel {
            return _subtextLabel
        }
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        let textLabel = UILabel(frame: .zero)
        textLabel.textColor = .white
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.contentView.addSubview(view)
        textLabel.numberOfLines = 0
        view.addSubview(textLabel)

        textLabel.addObserver(self, forKeyPath: "font", options: [.old,.new], context: kvoContext)

        _subtextLabel = textLabel
        return textLabel
    }
    open var customSubtextLabelFrame: CGRect? = nil

    /// Returns the image view of the pager view cell. Default is nil.
    @objc
    open var imageView: UIImageView? {
        if let _ = _imageView {
            return _imageView
        }
        let imageView = UIImageView(frame: .zero)
        self.contentView.addSubview(imageView)
        _imageView = imageView
        return imageView
    }

    fileprivate weak var _textLabel: UILabel?
    fileprivate weak var _subtextLabel: UILabel?
    fileprivate weak var _imageView: UIImageView?

    fileprivate let kvoContext = UnsafeMutableRawPointer(bitPattern: 0)
    fileprivate let selectionColor = UIColor(white: 0.2, alpha: 0.2)

    fileprivate weak var _selectedForegroundView: UIView?
    fileprivate var selectedForegroundView: UIView? {
        guard _selectedForegroundView == nil else {
            return _selectedForegroundView
        }
        guard let imageView = _imageView else {
            return nil
        }
        let view = UIView(frame: imageView.bounds)
        imageView.addSubview(view)
        _selectedForegroundView = view
        return view
    }

    open override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            if newValue {
                self.selectedForegroundView?.layer.backgroundColor = self.selectionColor.cgColor
            } else if !super.isSelected {
                self.selectedForegroundView?.layer.backgroundColor = UIColor.clear.cgColor
            }
        }
        get {
            return super.isHighlighted
        }
    }

    open override var isSelected: Bool {
        set {
            super.isSelected = newValue
            self.selectedForegroundView?.layer.backgroundColor = newValue ? self.selectionColor.cgColor : UIColor.clear.cgColor
        }
        get {
            return super.isSelected
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowRadius = 5
        self.contentView.layer.shadowOpacity = 0.75
        self.contentView.layer.shadowOffset = .zero
    }

    deinit {
        if let textLabel = _textLabel {
            textLabel.removeObserver(self, forKeyPath: "font", context: kvoContext)
        }
        if let textLabel = _subtextLabel {
            textLabel.removeObserver(self, forKeyPath: "font", context: kvoContext)
        }
    }
    private func updateTextLabelLayout() {
          if let textLabel = _textLabel {
            if let fr = customTextLabelFrame {
              textLabel.frame = fr
            } else {
              textLabel.superview!.frame = {
                  var rect = self.contentView.bounds
                  let height = (textLabel.font.pointSize*1.5) * CGFloat(textLabel.numberOfVisibleLines)
                  rect.size.height = height
                  rect.origin.y = self.contentView.frame.height-height
                  return rect
              }()
              textLabel.frame = {
                  var rect = textLabel.superview!.bounds
                  rect = rect.insetBy(dx: 8, dy: 0)
                  rect.size.height -= 1
                  rect.origin.y += 1
                  return rect
              }()
            }
          }
      }

      private func updateSubtextLabelLayout() {
            if let textLabel = _subtextLabel {
              if let fr = customSubtextLabelFrame {
                textLabel.frame = fr
              } else {
                textLabel.superview!.frame = {
                    var rect = self.contentView.bounds
                    let height = (textLabel.font.pointSize*1.5) * CGFloat(textLabel.numberOfVisibleLines)
                    rect.size.height = height
                    rect.origin.y = self.contentView.frame.height-height-textLabel.bounds.height
                    return rect
                }()
                textLabel.frame = {
                    var rect = textLabel.superview!.bounds
                    rect = rect.insetBy(dx: 8, dy: 0)
                    rect.size.height -= 1
                    rect.origin.y += 1
                    return rect
                }()
              }
            }
        }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = _imageView {
            imageView.frame = self.contentView.bounds
        }
        updateTextLabelLayout()
        updateSubtextLabelLayout()
        if let selectedForegroundView = _selectedForegroundView {
            selectedForegroundView.frame = self.contentView.bounds
        }
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == kvoContext {
            if keyPath == "font" {
                self.setNeedsLayout()
                updateTextLabelLayout()
                updateSubtextLabelLayout()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}

extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}
