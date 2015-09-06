//
//  NewspaperPageCell.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/9/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperPageCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    @IBInspectable var unselectedBorderColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    @IBInspectable var selectedBorderColor: UIColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFit
        iv.layer.borderWidth = 2.0
        return iv
    }()

    let scrollView: UIScrollView = {
        let v = UIScrollView()
        return v
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.frame = bounds
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        addSubview(scrollView)

        imageView.image = image
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)
    }

    override var selected: Bool {
        didSet {
            imageView.layer.borderColor = selected ? selectedBorderColor.CGColor : unselectedBorderColor.CGColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        println("frame: \(frame)")
        scrollView.frame = bounds
        imageView.frame = scrollView.bounds
    }

    // MARK: UIScrollViewDelegate methods

    func scrollViewDidScroll(scrollView: UIScrollView) { // any offset changes
    }

    func scrollViewDidZoom(scrollView: UIScrollView) { // any zoom scale changes
    }

    // called on start of dragging (may require some time and or distance to move)
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    }

    // called on finger up if the user dragged. velocity is in points/millisecond.
    // targetContentOffset may be changed to adjust where the scroll view comes to rest
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }

    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }

    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) { // called on finger up as we are moving
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) { // called when scroll view grinds to a halt
    }

    // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    }

    // return a view that will be scaled. if delegate returns nil, nothing happens
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    // called before the scroll view begins zooming its content
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
    }

    // scale between minimum and maximum. called after any 'bounce' animations
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
    }

    // return a yes if you want to scroll to the top. if not defined, assumes YES
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        return true
    }
    
    // called when scrolling animation finished. may be called immediately if already at top
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
    }
}
