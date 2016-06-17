import Foundation

extension UICollectionView {

    var headerPaths: [NSIndexPath] {
        return indexPathsForVisibleSupplementaryElementsOfKind(UICollectionElementKindSectionHeader)
    }

    var lastVisibleHeaderPath: NSIndexPath? {
        return headerPaths.last
    }

    var minVisibleHeaderY: CGFloat? {
        guard let path = lastVisibleHeaderPath else { return nil }
        let header = headerAtIndexPath(path)
        return header.frame.origin.y - self.contentOffset.y
    }

    func headerAtIndexPath(indexPath: NSIndexPath) -> UICollectionReusableView {
        return supplementaryViewForElementKind(UICollectionElementKindSectionHeader,
                                               atIndexPath: indexPath)
    }

    func dequeueCellForItemAtIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath) -> T {
        let identifier = NSStringFromClass(T.self)
        let cell = dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        return cell as! T
    }

    func dequeueHeaderForIndexPath(indexPath: NSIndexPath) -> UICollectionReusableView {
        return dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                                                      withReuseIdentifier: "Header",
                                                      forIndexPath: indexPath)
    }
}
