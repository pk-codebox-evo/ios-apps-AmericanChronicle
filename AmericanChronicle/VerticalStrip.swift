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
        view.registerClass(VerticalStripCell.self, forCellWithReuseIdentifier: "Cell")
        view.backgroundColor = Colors.blueGray
        view.pagingEnabled = true
        view.showsVerticalScrollIndicator = false;
        return view
    }()

    private let upButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.accessibilityLabel = "Up one page"
        button.setImage(UIImage.upArrowWithFillColor(UIColor.whiteColor()), forState: .Normal)
        button.setImage(UIImage.upArrowWithFillColor(UIColor.whiteColor()), forState: .Highlighted)
        let normalBgColor = Colors.lightBlueBright.colorWithAlphaComponent(0.5)
        button.setBackgroundImage(UIImage.imageWithFillColor(normalBgColor, borderColor: normalBgColor), forState: .Normal)
        button.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBlueBright, borderColor: Colors.lightBlueBright), forState: .Highlighted)
        return button
    }()

    private let downButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.accessibilityLabel = "Down one page"
        button.setImage(UIImage.downArrowWithFillColor(UIColor.whiteColor()), forState: .Normal)
        button.setImage(UIImage.downArrowWithFillColor(UIColor.whiteColor()), forState: .Highlighted)
        let normalBgColor = Colors.lightBlueBright.colorWithAlphaComponent(0.5)
        button.setBackgroundImage(UIImage.imageWithFillColor(normalBgColor, borderColor: normalBgColor), forState: .Normal)
        button.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBlueBright, borderColor: Colors.lightBlueBright), forState: .Highlighted)
        return button
    }()

    // MARK: Init methods

    func commonInit() {

        backgroundColor = Colors.darkBlue

        upButton.addTarget(self, action: #selector(VerticalStrip.upButtonTapped(_:)), forControlEvents: .TouchUpInside)
        addSubview(upButton)
        upButton.snp_makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(4)
            make.trailing.equalTo(-4)
            make.height.equalTo(44)
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
            make.bottom.equalTo(-8)
            make.leading.equalTo(4)
            make.trailing.equalTo(-4)
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