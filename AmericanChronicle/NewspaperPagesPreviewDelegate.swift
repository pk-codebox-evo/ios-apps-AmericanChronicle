//
//  NewspaperPagesPreviewDelegate.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/9/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

@objc protocol NewspaperPagesPreviewActionHandler {
    func didScrollToPreviewAtIndexPath(indexPath: NSIndexPath)
}

class NewspaperPagesPreviewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var actionHandler: NewspaperPagesPreviewActionHandler?
    var issue: NewspaperIssue?

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 20)
        let visibleHeight = collectionView.frame.size.height - collectionView.contentInset.top
        let height = (visibleHeight - 20)
        return CGSize(width: width, height: height)
    }

    // MARK: UIScrollViewDelegate methods

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) { // called when scroll view grinds to a halt
        if let cv = scrollView as? UICollectionView {
            let visible = cv.indexPathsForVisibleItems()
            if let indexPath = visible.last as? NSIndexPath where count(visible) == 1 {
                actionHandler?.didScrollToPreviewAtIndexPath(indexPath)
            }
        }
    }

    // MARK: UICollectionViewDelegate methods

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("\(self.dynamicType) | \(__FUNCTION__) | line \(__LINE__)")
    }
}
