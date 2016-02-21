import UIKit

class VerticalStripCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = Colors.darkGray
        label.font = Font.largeBody
        return label
    }()

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    func commonInit() {
        backgroundColor = Colors.lightBackground
        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        label.frame = bounds
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
}

class VerticalStrip: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    var userDidChangeValueHandler: ((Int) -> Void)?
    var items: [String] = [] { didSet { collectionView.reloadData() } }
    private var selectedIndex = 0

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        view.registerClass(VerticalStripCell.self, forCellWithReuseIdentifier: "Cell")
        view.backgroundColor = UIColor.blueColor()
        view.pagingEnabled = true
        view.showsVerticalScrollIndicator = false;
        return view
    }()

    private let upButton: UIButton = {
        let button = UIButton()
        button.accessibilityLabel = "Up one page"
        button.setImage(UIImage.upArrowWithFillColor(Colors.darkGray), forState: .Normal)
        button.setImage(UIImage.upArrowWithFillColor(Colors.lightBlueBright), forState: .Highlighted)
        button.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBackground, borderColor: Colors.lightBackground), forState: .Normal)
        button.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBackground, borderColor: Colors.lightBackground), forState: .Highlighted)
        return button
    }()

    private let downButton: UIButton = {
        let button = UIButton()
        button.accessibilityLabel = "Down one page"
        button.setImage(UIImage.downArrowWithFillColor(Colors.darkGray), forState: .Normal)
        button.setImage(UIImage.downArrowWithFillColor(Colors.lightBlueBright), forState: .Highlighted)
        button.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBackground, borderColor: Colors.lightBackground), forState: .Normal)
        button.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBackground, borderColor: Colors.lightBackground), forState: .Highlighted)
        return button
    }()

    // MARK: Init methods

    func commonInit() {

        backgroundColor = Colors.lightBackground

        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }

        upButton.addTarget(self, action: "upButtonTapped:", forControlEvents: .TouchUpInside)
        addSubview(upButton)
        upButton.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(44)
        }

        downButton.addTarget(self, action: "downButtonTapped:", forControlEvents: .TouchUpInside)
        addSubview(downButton)
        downButton.snp_makeConstraints { make in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(44)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    // MARK: Internal methods

    func jumpToItemAtIndex(index: Int) {
        guard index >= 0 else { return }
        guard index < items.count else { return }
        guard selectedIndex != index else { return }
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
        selectedIndex = index;
    }

    func upButtonTapped(button: UIButton) {
        let currentItemIndex = Int(collectionView.contentOffset.y / bounds.size.height)
        let nextItemIndex = currentItemIndex + 1
        if nextItemIndex < items.count {
            jumpToItemAtIndex(nextItemIndex)
            reportUserInitiatedChange()
        }
    }

    func downButtonTapped(button: UIButton) {
        let currentItemIndex = Int(collectionView.contentOffset.y / bounds.size.height)
        let previousItemIndex = currentItemIndex - 1
        if previousItemIndex >= 0 {
            jumpToItemAtIndex(previousItemIndex)
            reportUserInitiatedChange()
        }
    }

    // MARK: Private methods

    private func reportUserInitiatedChange() {
        userDidChangeValueHandler?(selectedIndex);
    }


    // MARK: UICollectionViewDataSource methods

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! VerticalStripCell
        cell.text = items[indexPath.item]
        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    // MARK: UICollectionViewDelegate methods

//    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//
//    }
//
//    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
//
//    }
//
//    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
//
//    }
//
//    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//
//    }
//
//    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//
//    }

//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//
//    }
//
//    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//
//    }

    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

    }

//    func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
//
//    }
//    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//
//    }
//
//    func collectionView(collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
//
//    }
//
//    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//
//    }
//
//    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) -> Bool {
//
//    }
//
//    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
//        
//    }
//    
//    func collectionView(collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout! {
//        
//    }

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return collectionView.bounds.size
    }

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0
    }

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0
    }

    // MARK: UIScrollViewDelegate methods

//
//    func scrollViewDidZoom(scrollView: UIScrollView) { // any zoom scale changes
//    }
//
//    // called on start of dragging (may require some time and or distance to move)
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//    }
//
//    // called on finger up if the user dragged. velocity is in points/millisecond.
//    // targetContentOffset may be changed to adjust where the scroll view comes to rest
//    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//    }
//
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return } // Only act if the scrollViewDidEndDecelerating method won't be called.
        let mostVisibleItem = Int(round(collectionView.contentOffset.y / frame.size.height))
        jumpToItemAtIndex(mostVisibleItem)
        reportUserInitiatedChange()
    }

//    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) { // called on finger up as we are moving
//    }
//
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) { // called when scroll view grinds to a halt
        let mostVisibleItem = Int(round(collectionView.contentOffset.y / frame.size.height))
        jumpToItemAtIndex(mostVisibleItem)
        reportUserInitiatedChange()
    }
//
//    // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        let mostVisibleItem = Int(round(collectionView.contentOffset.y / frame.size.height))
//        self.reportUserInitiatedChangeIfNeeded(mostVisibleItem)
    }
//
//    // return a view that will be scaled. if delegate returns nil, nothing happens
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return nil
//    }
//
//    // called before the scroll view begins zooming its content
//    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
//    }
//
//    // scale between minimum and maximum. called after any 'bounce' animations
//    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
//    }
//
//    // return a yes if you want to scroll to the top. if not defined, assumes YES
//    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
//        return true
//    }
//    
//    // called when scrolling animation finished. may be called immediately if already at top
//    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
//    }
}