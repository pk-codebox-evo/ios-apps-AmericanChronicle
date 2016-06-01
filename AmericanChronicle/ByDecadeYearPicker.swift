//
//  ByDecadeYearPicker.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 2/21/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import UIKit

class ByDecadeYearPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    private static let decadeTransitionScrollArea: CGFloat = 100.0
    private static let headerReuseIdentifier = "Header"

    var earliestYear: Int? {
        didSet { updateYearsAndDecades() }
    }

    var latestYear: Int? {
        didSet { updateYearsAndDecades() }
    }

    var selectedYear: Int? {
        didSet {
            if let year = selectedYear {
                let decadeString = "\(year/10)0s"
                if let section = decades.indexOf(decadeString), item = yearsByDecade[decadeString]?.indexOf("\(year)") {
                        yearCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: item, inSection: section),
                                                                 animated: true,
                                                                 scrollPosition: .None)
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
        view.registerClass(ByDecadeYearPickerCell.self, forCellWithReuseIdentifier: ByDecadeYearPickerCell.defaultReuseIdentifier)
        view.registerClass(UICollectionReusableView.self,
                           forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                           withReuseIdentifier: "Header");
        return view
    }()

    private var yearsByDecade: [String: [String]] = [:]
    private var decades: [String] = []
    private var previousContentOffset: CGPoint = CGPointZero
    private var shouldIgnoreOffsetChangesUntilNextRest = false
    private var currentDecadeTransitionMinY: CGFloat?

    // MARK: Init methods

    func commonInit() {

        backgroundColor = Colors.lightBackground

        decadeStrip.userDidChangeValueHandler = { [weak self] index in
            self?.shouldIgnoreOffsetChangesUntilNextRest = true
            let indexPath = NSIndexPath(forItem: 0, inSection: index)
            self?.yearCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
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

    // MARK: Private methods

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

    private func currentTopHeaderVisibleY() -> CGFloat {
        let visibleHeaderPaths = yearCollectionView.indexPathsForVisibleSupplementaryElementsOfKind(UICollectionElementKindSectionHeader)
        guard let visibleHeaderPath = visibleHeaderPaths.first else { return 0 }
        let header = yearCollectionView.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: visibleHeaderPath)
        return (header.frame.origin.y - yearCollectionView.contentOffset.y)
    }

    private func settle() {
        guard !shouldIgnoreOffsetChangesUntilNextRest else { return }

        guard let visibleHeaderPath = yearCollectionView.indexPathsForVisibleSupplementaryElementsOfKind(UICollectionElementKindSectionHeader).first else { return }

        let header = yearCollectionView.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: visibleHeaderPath)
        let distanceFromTop = header.frame.origin.y - yearCollectionView.contentOffset.y
        let halfwayPoint = yearCollectionView.frame.size.height / 2.0
        var currentSection = visibleHeaderPath.section
        if ((distanceFromTop >= halfwayPoint) && (currentSection > 0)) {
            currentSection -= 1
        }

        decadeStrip.jumpToItemAtIndex(currentSection)
    }

    private func updateCurrentDecadeTransitionMinY() {

        let topHeaderY = currentTopHeaderVisibleY()

        let visibleHalfwayY = yearCollectionView.frame.size.height / 2.0
        let typicalDecadeTransitionMinY = visibleHalfwayY - (ByDecadeYearPicker.decadeTransitionScrollArea / 2.0)
        let typicalDecadeTransitionMaxY = visibleHalfwayY + (ByDecadeYearPicker.decadeTransitionScrollArea / 2.0)

        // if the year collectionView is resting at a point where transition
        // between decades should happen, then treat this as the decade's "full"
        // position until the drag ends.
        if ((topHeaderY >= typicalDecadeTransitionMinY) && (topHeaderY <= typicalDecadeTransitionMaxY)) {
            currentDecadeTransitionMinY = topHeaderY
        } else {
            currentDecadeTransitionMinY = typicalDecadeTransitionMinY
        }
    }

    // MARK: UICollectionViewDataSource methods

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return decades.count
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let years = yearsByDecade[decades[section]]
        return years?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ByDecadeYearPickerCell.defaultReuseIdentifier,
                                                                         forIndexPath: indexPath) as! ByDecadeYearPickerCell
        let decade = decades[indexPath.section]
        cell.text = yearsByDecade[decade]?[indexPath.item]
        return cell
    }

    func collectionView(collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                                                                         withReuseIdentifier: ByDecadeYearPicker.headerReuseIdentifier,
                                                                         forIndexPath: indexPath)
        view.backgroundColor = Colors.offWhite
        return view;
    }

    // MARK: UICollectionViewDelegate methods

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        updateCurrentDecadeTransitionMinY()
        let decade = decades[indexPath.section]
        if let year = yearsByDecade[decade]?[indexPath.item] {
            yearTapHandler?(year)
        }
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

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 320.0, height: 2.0)
    }

    // MARK: UIScrollViewDelegate methods

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if (scrollView.decelerating) {
            // Ignore
            return
        }
        updateCurrentDecadeTransitionMinY()
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!scrollView.decelerating) {
            shouldIgnoreOffsetChangesUntilNextRest = false
        }
        settle()
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (!scrollView.dragging) {
            shouldIgnoreOffsetChangesUntilNextRest = false
        }
        settle()
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard !shouldIgnoreOffsetChangesUntilNextRest else { return }
        guard let visibleHeaderPath = yearCollectionView.indexPathsForVisibleSupplementaryElementsOfKind(UICollectionElementKindSectionHeader).first else { return }
        guard let minTransitionY = currentDecadeTransitionMinY else { return }

        let maxTransitionY = minTransitionY + ByDecadeYearPicker.decadeTransitionScrollArea
        let topHeaderY = currentTopHeaderVisibleY()
        if ((topHeaderY >= minTransitionY) && (topHeaderY <= maxTransitionY)) { // Within range of transition
            let relativeY = topHeaderY - minTransitionY
            let visiblePercent = 1.0 - (relativeY / 100.0)
            decadeStrip.revealElementAtIndex(visibleHeaderPath.section, fromBottomWithVisiblePercent: visiblePercent)
        } else if (topHeaderY < minTransitionY) {
            decadeStrip.revealElementAtIndex(visibleHeaderPath.section, fromBottomWithVisiblePercent: 1.0)
        } else if (topHeaderY > maxTransitionY) {
            decadeStrip.revealElementAtIndex(visibleHeaderPath.section - 1, fromBottomWithVisiblePercent: 1.0)
        }
    }
}