//
//  UICollectionView+AMC.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 6/7/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import Foundation

extension UICollectionView {

    var lastVisibleHeaderPath: NSIndexPath? {
        let paths = self.indexPathsForVisibleSupplementaryElementsOfKind(UICollectionElementKindSectionHeader)
        return paths.last
    }

    var minVisibleHeaderY: CGFloat? {
        let paths = self.indexPathsForVisibleSupplementaryElementsOfKind(UICollectionElementKindSectionHeader)
        guard let path = paths.first else { return nil }
        let header = self.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: path)
        return header.frame.origin.y - self.contentOffset.y
    }
}