import UIKit

class VerticalStrip: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    var userDidChangeValueHandler: ((Int) -> Void)?
    var items: [String] = [] { didSet { collectionView.reloadData() } }
    var selectedIndex: Int {
        let val = collectionView.contentOffset.y / collectionView.frame.height
        let rounded = round(val)
        let roundedInt = Int(rounded)
        return roundedInt
    }
    var itemHeight: CGFloat {
        return collectionView.frame.height
    }
    var yOffset: CGFloat {
        return collectionView.contentOffset.y
    }

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical

        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        view.bounces = false
        view.registerClass(VerticalStripCell.self, forCellWithReuseIdentifier: "Cell")
        view.backgroundColor = UIColor.whiteColor()
        view.pagingEnabled = true
        view.showsVerticalScrollIndicator = false;
        return view
    }()

    private static func newButtonWithImage(image: UIImage, accessibilityLabel: String) -> UIButton {
        let button = UIButton()
        button.accessibilityLabel = accessibilityLabel
        button.layer.cornerRadius = 0
        button.clipsToBounds = true
        button.setImage(image, forState: .Normal)
        button.setImage(image, forState: .Highlighted)
        button.setBackgroundImage(UIImage.imageWithFillColor(UIColor.clearColor()), forState: .Normal)
        button.setBackgroundImage(UIImage.imageWithFillColor(UIColor.clearColor()), forState: .Highlighted)
        return button
    }

    private let upButton: UIButton = {
        let arrowImage = UIImage.upArrowWithFillColor(Colors.lightBlueBright)
        let button = VerticalStrip.newButtonWithImage(arrowImage, accessibilityLabel: "Up one page")
        return button
    }()

    private static let separatorColor = UIColor.whiteColor()

    private let upButtonSeparator: UIImageView = {
        let v = UIImageView(image: UIImage.imageWithFillColor(VerticalStrip.separatorColor))
        return v
    }()

    private let downButton: UIButton = {
        let arrowImage = UIImage.downArrowWithFillColor(Colors.lightBlueBright)
        let button = VerticalStrip.newButtonWithImage(arrowImage, accessibilityLabel: "Down one page")
        return button
    }()

    private let downButtonSeparator: UIImageView = {
        let v = UIImageView(image: UIImage.imageWithFillColor(VerticalStrip.separatorColor))
        return v
    }()

    // MARK: Init methods

    func commonInit() {

        backgroundColor = UIColor.whiteColor()
        let buttonHeight = 44

        upButton.addTarget(self, action: #selector(VerticalStrip.upButtonTapped(_:)), forControlEvents: .TouchUpInside)
        addSubview(upButton)
        upButton.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(buttonHeight)
        }

        insertSubview(upButtonSeparator, belowSubview: upButton)
        upButtonSeparator.snp_makeConstraints { make in
            make.bottom.equalTo(upButton.snp_bottom)
            make.leading.equalTo(12.0)
            make.trailing.equalTo(-12.0)
            make.height.equalTo(1.0)
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.snp_makeConstraints { make in
            make.top.equalTo(upButton.snp_bottom)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }

        downButton.addTarget(self, action: #selector(VerticalStrip.downButtonTapped(_:)), forControlEvents: .TouchUpInside)
        addSubview(downButton)
        downButton.snp_makeConstraints { make in
            make.top.equalTo(collectionView.snp_bottom)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(buttonHeight)
        }

        insertSubview(downButtonSeparator, belowSubview: downButton)
        downButtonSeparator.snp_makeConstraints { make in
            make.top.equalTo(downButton.snp_top)
            make.leading.equalTo(upButtonSeparator.snp_leading)
            make.trailing.equalTo(upButtonSeparator.snp_trailing)
            make.height.equalTo(upButtonSeparator.snp_height)
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

    func showItemAtIndex(index: Int, withFractionScrolled fractionScrolled: CGFloat, animated: Bool = false) {
        let fullyVisibleY = CGFloat(index) * collectionView.frame.height
        var newOffset = collectionView.contentOffset
        newOffset.y = fullyVisibleY + (fractionScrolled * collectionView.frame.height)
        if (newOffset.y < 0) {
            newOffset.y = 0
        } else if (newOffset.y > (collectionView.contentSize.height - collectionView.frame.height)) {
            newOffset.y = (collectionView.contentSize.height - collectionView.frame.height)
        }

        collectionView.setContentOffset(newOffset, animated: animated)
    }

    func jumpToItemAtIndex(index: Int) {
        guard index >= 0 else { return }
        guard index < items.count else { return }

        showItemAtIndex(index, withFractionScrolled: 0, animated: true)
    }

    func upButtonTapped(button: UIButton) {
        let currentItemIndex = Int(collectionView.contentOffset.y / collectionView.frame.height)
        let nextItemIndex = currentItemIndex + 1
        if nextItemIndex < items.count {
            jumpToItemAtIndex(nextItemIndex)
            reportUserInitiatedChangeToIndex(nextItemIndex)
        }
    }

    func downButtonTapped(button: UIButton) {
        let currentItemIndex = Int(collectionView.contentOffset.y / collectionView.frame.height)
        let previousItemIndex = currentItemIndex - 1
        if previousItemIndex >= 0 {
            jumpToItemAtIndex(previousItemIndex)
            reportUserInitiatedChangeToIndex(previousItemIndex)
        }
    }

    // MARK: Private methods

    private func reportUserInitiatedChangeToIndex(index: Int) {
        userDidChangeValueHandler?(index);
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

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return collectionView.frame.size
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

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return } // Only act if the scrollViewDidEndDecelerating method won't be called.
        let mostVisibleItem = Int(round(collectionView.contentOffset.y / collectionView.frame.height))
        jumpToItemAtIndex(mostVisibleItem)
        reportUserInitiatedChangeToIndex(mostVisibleItem)
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) { // called when scroll view grinds to a halt
        let mostVisibleItem = Int(round(collectionView.contentOffset.y / collectionView.frame.height))
        jumpToItemAtIndex(mostVisibleItem)
        reportUserInitiatedChangeToIndex(mostVisibleItem)
    }
}