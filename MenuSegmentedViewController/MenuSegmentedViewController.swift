//
//  MenuSegmentedViewController.swift
//  MenuSegmentedViewController
//
//  Created by Christos Bimpas on 25/11/16.
//  Copyright © 2016 Christos Bimpas. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

import SnapKit

public class NDSegmentedViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    public var viewControllers: [UIViewController] = []
    public var titleViewHeight: Float = 34
    public var titleFont:  UIFont?
    public var titleColor: UIColor?
    public var underlineColor: UIColor?
    public var minAlpha: CGFloat = 0.2
    
    private var titleScrollView: UIScrollView!
    private var contentScrollView: UIScrollView!
    private var buttonViews: [UIButton] = []
    private var underlineViews: [UIView] = []
    private var shouldUpdateAlphaOnScroll = true
    private var index: Int = 0
    private var previousXContentOffset: CGFloat = 0.0
    var shadowImage: UIImage!
    
    //MARK: -
    
    public init() {
        super.init(nibName:nil, bundle:nil)
        self.view.backgroundColor = UIColor.white
        
        titleScrollView = UIScrollView()
        titleScrollView.isPagingEnabled = true
        titleScrollView.showsHorizontalScrollIndicator = false
        titleScrollView.backgroundColor = UIColor.white
        titleScrollView.bounces = false
        titleScrollView.delegate = self
        
        self.view.addSubview(titleScrollView)
        titleScrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(titleViewHeight)
        }
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect.init(x: 0.0, y: Double(titleViewHeight - 1.0), width: Double(self.view.frame.size.width), height: 1.0)
        bottomBorder.backgroundColor = UIColor.init(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0).cgColor
        bottomBorder.shadowColor = UIColor.gray.cgColor
        bottomBorder.shadowRadius = 5.0
        bottomBorder.shadowOffset = CGSize(width: 0, height: 1)
        titleScrollView.layer.addSublayer(bottomBorder)
        
        contentScrollView = UIScrollView()
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        contentScrollView.backgroundColor = UIColor.clear
        self.view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(titleScrollView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        let innerRect = CGRect.init(x: 0.0, y: 3.0 + CGFloat(titleViewHeight), width: self.view.frame.size.width, height: 1.0)
        let shadowView = UIView(frame: innerRect)
        shadowView.backgroundColor = UIColor.clear
        shadowView.layer.masksToBounds = false;
        shadowView.layer.shadowRadius = 0.7
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        self.view.addSubview(shadowView)
        
        shadowImage = self.navigationController?.navigationBar.shadowImage
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
    }
    
    func set(viewControllers controllers: [UIViewController]) {
        viewControllers = controllers
        
        var previousButton: UIButton!
        for viewController in viewControllers {
            let button = UIButton()
            button.setTitle(viewController.title, for: UIControlState.normal)
            if let font = titleFont {
                button.titleLabel?.font = font
            }
            if let color = titleColor {
                button.setTitleColor(color, for: UIControlState.normal)
            } else {
                button.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            button.addTarget(self, action: #selector(didTapOnButton(sender:)), for: UIControlEvents.touchUpInside)
            titleScrollView.addSubview(button)
            button.snp.makeConstraints({ (make) in
                if previousButton == nil {
                    make.left.equalTo(titleScrollView)
                } else {
                    make.left.equalTo(previousButton.snp.right)
                }
                make.top.equalTo(titleScrollView)
                make.height.equalTo(titleViewHeight - 8)
                make.width.equalTo(self.view.frame.size.width / CGFloat(viewControllers.count))
                if viewControllers.last == viewController {
                    make.right.equalTo(titleScrollView)
                }
            })
            buttonViews.append(button)
            
            let underlineView = UIView()
            if let color = underlineColor {
                underlineView.backgroundColor = color
            } else {
                underlineView.backgroundColor = UIColor.black
            }
            
            underlineView.alpha = viewControllers.first == viewController ? 1.0 : minAlpha
            titleScrollView.addSubview(underlineView)
            underlineView.snp.makeConstraints { (make) in
                make.left.equalTo(button).offset(4)
                make.right.equalTo(button).offset(-4)
                make.height.equalTo(4)
                make.top.equalTo(button.snp.bottom)
                make.bottom.equalTo(titleScrollView).offset(-6)
            }
            underlineViews.append(underlineView)
            previousButton = button
        }
        
        var previousView: UIView!
        for viewController in viewControllers {
            var contentView = UIView()
            contentView = viewController.view
            
            contentScrollView.addSubview(contentView)
            contentView.snp.makeConstraints({ (make) in
                if previousView == nil {
                    make.left.equalTo(contentScrollView)
                } else {
                    make.left.equalTo(previousView.snp.right)
                }
                make.top.bottom.equalTo(contentScrollView)
                make.width.equalTo(contentScrollView)
                make.height.equalTo(contentScrollView)
                if viewControllers.last == viewController {
                    make.right.equalTo(contentScrollView)
                }
            })
            previousView = contentView
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIButton
    
    func didTapOnButton(sender: UIButton) {
        shouldUpdateAlphaOnScroll = false
        let nextIndex = buttonViews.index(of: sender)
        UIView.animate(withDuration: 0.0, animations: {
            self.contentScrollView.contentOffset = CGPoint.init(x: CGFloat(nextIndex!) * self.contentScrollView.frame.size.width, y: self.contentScrollView.contentOffset.y)
        }) { (_) in
            self.shouldUpdateAlphaOnScroll = true
            self.contentDidScroll(withOffset: CGFloat(nextIndex!))
        }
        
        let currentUndelineView = underlineViews[index]
        let nextUndelineView = underlineViews[nextIndex!]
        UIView.animate(withDuration: 0.25) {
            currentUndelineView.alpha = self.minAlpha
            nextUndelineView.alpha = 1.0
        }
        index = nextIndex!
    }
    
    //MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / scrollView.frame.size.width
        self.contentDidScroll(withOffset: offset)
        
        if scrollView == contentScrollView && shouldUpdateAlphaOnScroll {
            
            if offset > CGFloat(viewControllers.count - 1) {
                return
            }
            var currentIndex: Int!
            let nextIndex: Int!
            
            if previousXContentOffset < scrollView.contentOffset.x {
                currentIndex = Int(floor(offset))
                nextIndex = Int(ceil(offset))
            } else if previousXContentOffset > scrollView.contentOffset.x {
                currentIndex = Int(ceil(offset))
                nextIndex = Int(floor(offset))
            } else {
                return
            }
            
            let progress = fabs(CGFloat(nextIndex) - offset)
            let currentIndexValid = underlineViews.indices.contains(currentIndex)
            if currentIndexValid {
                let currentUnderlineView = underlineViews[currentIndex]
                currentUnderlineView.alpha = (1 - minAlpha) * progress + minAlpha
            }
            let nextIndexValid = underlineViews.indices.contains(nextIndex)
            if nextIndexValid {
                let nextUnderlineView = underlineViews[nextIndex]
                nextUnderlineView.alpha = (1 - minAlpha) * (1 - progress) + minAlpha
            }
            index = nextIndex
        }
        previousXContentOffset = scrollView.contentOffset.x
        
        
    }
    
    public func contentDidScroll(withOffset offset: CGFloat) {
        
    }
    
}
