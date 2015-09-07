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
        var size = CGSizeZero
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let width = collectionView.frame.size.width - (layout.sectionInset.left + layout.sectionInset.right)

            let height = collectionView.frame.size.height - (layout.sectionInset.top + layout.sectionInset.bottom + collectionView.contentInset.top + collectionView.contentInset.bottom)
            size = CGSize(width: width, height: height)
        }
        return size
    }

    // MARK: UIScrollViewDelegate methods

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) { // called when scroll view grinds to a halt
        if let cv = scrollView as? UICollectionView {
            let visible = cv.indexPathsForVisibleItems()
            if let indexPath = visible.last where visible.count == 1 {
                actionHandler?.didScrollToPreviewAtIndexPath(indexPath)
            }
        }
    }
}
