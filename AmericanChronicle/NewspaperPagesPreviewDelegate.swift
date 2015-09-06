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
//            println("collectionView.frame: \(collectionView.frame)")
//            println("collectionView.contentInset: top = \(collectionView.contentInset.top), right = \(collectionView.contentInset.right), bottom = \(collectionView.contentInset.bottom), left = \(collectionView.contentInset.left)")
//            println("collectionView.contentSize: \(collectionView.contentSize)")
//            println("layout.sectionInset: top = \(layout.sectionInset.top), right = \(layout.sectionInset.right), bottom = \(layout.sectionInset.bottom), left = \(layout.sectionInset.left)")
//            println("layout.minimumInteritemSpacing: \(layout.minimumInteritemSpacing)")
//            println("layout.minimumLineSpacing: \(layout.minimumLineSpacing)")

            let height = collectionView.frame.size.height - (layout.sectionInset.top + layout.sectionInset.bottom + collectionView.contentInset.top + collectionView.contentInset.bottom)
            size = CGSize(width: width, height: height)
        }
//        println("size: \(size)")
        return size
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
}
