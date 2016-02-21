//
//  ByDecadeYearPicker.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 2/21/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import UIKit

class ByDecadeYearPickerCell: UICollectionViewCell {

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = Font.largeBody
        label.textColor = Colors.darkGray
        return label
    }()

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    override var highlighted: Bool {
        didSet {
            updateFormat()
        }
    }

    override var selected: Bool {
        didSet {
            updateFormat()
        }
    }

    func commonInit() {
        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        label.frame = bounds
        addSubview(label)
        updateFormat()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    private func updateFormat() {
        if self.highlighted {
            self.contentView.backgroundColor = Colors.lightBlueBright
            self.label.textColor = UIColor.whiteColor()
        } else if self.selected {
            self.contentView.backgroundColor = Colors.lightBlueBright
            self.label.textColor = UIColor.whiteColor()
        } else {
            self.contentView.backgroundColor = Colors.lightBackground
            self.label.textColor = Colors.darkGray
        }
    }
}



class ByDecadeYearPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    var selectedYear: Int? {
        didSet {
            if let year = selectedYear {
                let decadeString = "\(year/10)0s"
                if let section = decades.indexOf(decadeString), item = yearsByDecade[decadeString]?.indexOf("\(year)") {
                        yearCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: item, inSection: section), animated: true, scrollPosition: .Top)
                        return
                }
            }
            yearCollectionView.selectItemAtIndexPath(nil, animated: false, scrollPosition: .Top)
        }
    }
    var yearTapHandler: ((String) -> Void)?
    private let decadeStrip: VerticalStrip = {
        let strip = VerticalStrip()
        strip.backgroundColor = Colors.lightBackground
        return strip
    }()
    private let yearCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        view.backgroundColor = Colors.lightBackground
        view.registerClass(ByDecadeYearPickerCell.self, forCellWithReuseIdentifier: "Cell")
        return view
    }()

    var earliestYear: Int? {
        didSet {
            updateYearsAndDecades()
        }
    }

    var latestYear: Int? {
        didSet {
            updateYearsAndDecades()
        }
    }

    private func updateYearsAndDecades() {
        yearsByDecade = [:]
        decades = []
        if let earliestYear = earliestYear, latestYear = latestYear where earliestYear < latestYear {
            let earliestDecade = Int(Float(earliestYear) / 10.0) * 10
            let latestDecade = Int(Float(latestYear) / 10.0) * 10
            var decade = earliestDecade
            while (decade <= latestDecade) {
                decades.append("\(decade)s")
                let earliestDecadeYear = max(decade, earliestYear)
                let latestDecadeYear = min(decade + 9, latestYear)
                let yearsInDecade = (earliestDecadeYear...latestDecadeYear).map { "\($0)" }
                yearsByDecade["\(decade)s"] = yearsInDecade
                decade += 10
            }
            decadeStrip.items = decades
        }
        yearCollectionView.reloadData()
    }

    private var yearsByDecade: [String: [String]] = [:]
    private var decades: [String] = []

    func commonInit() {

        backgroundColor = Colors.lightBackground

        decadeStrip.userDidChangeValueHandler = { index in
            let indexPath = NSIndexPath(forItem: 0, inSection: index)
            self.yearCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
        addSubview(decadeStrip)
        decadeStrip.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.snp_width).multipliedBy(0.33)
        }

        let verticalBorder = UIImageView(image: UIImage.imageWithFillColor(Colors.lightGray, borderColor: Colors.lightGray))
        addSubview(verticalBorder)
        verticalBorder.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(decadeStrip.snp_trailing)
            make.width.equalTo(1.0/UIScreen.mainScreen().scale)
        }

        yearCollectionView.delegate = self
        yearCollectionView.dataSource = self
        addSubview(yearCollectionView)
        yearCollectionView.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(verticalBorder.snp_trailing)
            make.trailing.equalTo(0)
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

    // MARK: UICollectionViewDataSource methods

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let years = yearsByDecade[decades[section]]
        return years?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ByDecadeYearPickerCell
        let decade = decades[indexPath.section]
        cell.text = yearsByDecade[decade]?[indexPath.item]
        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return decades.count
    }

    // MARK: UICollectionViewDelegate methods

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
    }

    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let decade = decades[indexPath.section]
        if let year = yearsByDecade[decade]?[indexPath.item] {
            yearTapHandler?(year)
        }
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    }

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.size.width, height: 44)
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

    private var previousContentOffset: CGPoint = CGPointZero

    private func increaseDecadeIfNeeded(collectionView: UICollectionView) {
        let topVisiblePoint = collectionView.contentOffset
        guard let topVisibleIndexPath = collectionView.indexPathForItemAtPoint(topVisiblePoint) else { return }

        let bottomPoint = CGPoint(x: 0, y: collectionView.contentOffset.y + collectionView.frame.height)
        guard let bottomVisibleIndexPath = collectionView.indexPathForItemAtPoint(bottomPoint) else { return }

        if topVisibleIndexPath.section == bottomVisibleIndexPath.section {
            return
        }

        let firstIndexPathInBottomDecade = NSIndexPath(forItem: 0, inSection: bottomVisibleIndexPath.section)
        guard let firstCellInBottomDecade = yearCollectionView.cellForItemAtIndexPath(firstIndexPathInBottomDecade) else { return }

        let convertedPoint = yearCollectionView.convertPoint(firstCellInBottomDecade.frame.origin, toView: self)
        if convertedPoint.y < (self.frame.size.height / 2.0) {
            decadeStrip.jumpToItemAtIndex(bottomVisibleIndexPath.section)
        }
    }

    private func decreaseDecadeIfNeeded(collectionView: UICollectionView) {
        let topVisiblePoint = collectionView.contentOffset
        guard let topVisibleIndexPath = collectionView.indexPathForItemAtPoint(topVisiblePoint) else { return }

        let bottomPoint = CGPoint(x: 0, y: collectionView.contentOffset.y + collectionView.frame.height)
        guard let bottomVisibleIndexPath = collectionView.indexPathForItemAtPoint(bottomPoint) else { return }

        if topVisibleIndexPath.section == bottomVisibleIndexPath.section {
            return
        }

        let firstIndexPathInBottomDecade = NSIndexPath(forItem: 0, inSection: bottomVisibleIndexPath.section)
        guard let firstCellInBottomDecade = yearCollectionView.cellForItemAtIndexPath(firstIndexPathInBottomDecade) else { return }

        let convertedPoint = yearCollectionView.convertPoint(firstCellInBottomDecade.frame.origin, toView: self)
        if convertedPoint.y >= (self.frame.size.height / 2.0) {
            decadeStrip.jumpToItemAtIndex(topVisibleIndexPath.section)
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }

        let isScrollingTowardsBottom = scrollView.contentOffset.y > previousContentOffset.y
        previousContentOffset = scrollView.contentOffset

        if isScrollingTowardsBottom {
            self.increaseDecadeIfNeeded(collectionView)
        } else {
            self.decreaseDecadeIfNeeded(collectionView)
        }
    }
}