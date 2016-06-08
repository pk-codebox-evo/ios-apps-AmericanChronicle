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

    private let decadeStrip: VerticalStrip

    let yearCollectionView: UICollectionView = {
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

    init(decadeStrip: VerticalStrip = VerticalStrip()) {
        self.decadeStrip = decadeStrip
        super.init(frame: CGRectZero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private func settle() {
        guard !shouldIgnoreOffsetChangesUntilNextRest else { return }

        guard let visibleHeaderPath = yearCollectionView.lastVisibleHeaderPath else { return }

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

        let topHeaderY = yearCollectionView.minVisibleHeaderY

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

        let headerPaths = yearCollectionView.indexPathsForVisibleSupplementaryElementsOfKind(UICollectionElementKindSectionHeader)

        guard let lowerSectionHeaderPath = headerPaths.last else { return }

        // When the header's y origin is here, the lower section should be
        // shown at 100%.
        guard let fullLowerSectionYBoundary = currentDecadeTransitionMinY else { return }
        // When the header's y origin is here, the upper section should be
        // shown at 100%
        let fullUpperSectionYBoundary = fullLowerSectionYBoundary + ByDecadeYearPicker.decadeTransitionScrollArea


        let lowerSectionHeader = yearCollectionView.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: lowerSectionHeaderPath)


        // Position of the header's y origin to the user
        let perceivedLowerSectionY = lowerSectionHeader.frame.origin.y - yearCollectionView.contentOffset.y


        // The first visible header marks the beginning of the lower section.
        // VerticalStrip wants the upper section, so subtract 1 (unless 0)
        let upperSection = max(lowerSectionHeaderPath.section - 1, 0)


        if ((perceivedLowerSectionY >= fullLowerSectionYBoundary) && (perceivedLowerSectionY <= fullUpperSectionYBoundary)) {
//            print("[RP] perceivedLowerSectionY (\(perceivedLowerSectionY)) is within the transition zone")

            // How much would the user need to scroll before upper section should be fully visible?
            let distanceFromFullUpper = fullUpperSectionYBoundary - perceivedLowerSectionY

            let fractionScrolled = distanceFromFullUpper / ByDecadeYearPicker.decadeTransitionScrollArea
//            print("[RP] \(upperSection) @ \(fractionScrolled) scrolled")
            decadeStrip.showItemAtIndex(upperSection, withFractionScrolled: fractionScrolled)
        } else if (perceivedLowerSectionY < fullLowerSectionYBoundary) { // Show lower section entirely
//            print("[RP] perceivedLowerSectionY (\(perceivedLowerSectionY)) is up enough that section \(lowerSectionHeaderPath.section) should be shown entirely")
            decadeStrip.showItemAtIndex(lowerSectionHeaderPath.section, withFractionScrolled: 0)
        } else if (perceivedLowerSectionY > fullUpperSectionYBoundary) {
//            print("[RP] perceivedLowerSectionY (\(perceivedLowerSectionY)) is down enough that section \(upperSection) section should be shown entirely")
            decadeStrip.showItemAtIndex(upperSection, withFractionScrolled: 0)
        }
    }
}