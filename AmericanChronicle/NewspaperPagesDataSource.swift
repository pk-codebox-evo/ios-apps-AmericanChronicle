//
//  NewspaperPagesDataSource.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/9/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperPagesDataSource: NSObject, UICollectionViewDataSource {

    var issue: NewspaperIssue?
    var didZoomCallback: ((UIScrollView) -> ())?

    // MARK: UICollectionViewDataSource methods

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return issue?.pages.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! NewspaperPageCell
        cell.image = UIImage(named: issue?.pages[indexPath.row].imageName ?? "")
        cell.didZoomCallback = { [weak self] scrollView in
            self?.didZoomCallback?(scrollView)
        }
        println("cell.image: \(cell.image)")
        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}
