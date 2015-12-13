//
//  SearchFiltersViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/11/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import FSCalendar
import SnapKit

extension UIViewController {
    func setChildViewController(viewController : UIViewController, inContainer containerView: UIView) {
        if let onlyChild = self.childViewControllers.first {
            onlyChild.willMoveToParentViewController(nil)
            onlyChild.view.removeFromSuperview()
            onlyChild.removeFromParentViewController()
        }

        self.addChildViewController(viewController)
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
}

class FilterCell: UICollectionViewCell {
    let titleLabel: UILabel = UILabel()
    let subtitleLabel: UILabel = UILabel()

    func commonInit() {
        backgroundColor = UIColor.whiteColor()
        layer.borderColor = UIColor.darkGrayColor().CGColor
        layer.borderWidth = 1.0 / UIScreen.mainScreen().scale

        addSubview(titleLabel)
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.snp_makeConstraints { [weak self] make in
            if let _ = self {
                make.top.equalTo(14.0)
                make.leading.equalTo(20.0)
                make.trailing.equalTo(-20.0)
            }
        }

        addSubview(subtitleLabel)
        subtitleLabel.text = "This is subtitle"
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        subtitleLabel.textColor = UIColor.darkGrayColor()

        subtitleLabel.snp_makeConstraints { [weak self] make in
            if let myself = self {
                make.top.equalTo(myself.titleLabel.snp_bottom)
                make.leading.equalTo(20.0)
                make.trailing.equalTo(-20.0)
            }
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
}

class EmptyLocationCell: UICollectionViewCell {
    let titleLabel: UILabel = UILabel()

    func commonInit() {
        backgroundColor = UIColor.clearColor()

        addSubview(titleLabel)
        titleLabel.text = "Anywhere."
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        titleLabel.textColor = UIColor.darkGrayColor()
        titleLabel.snp_makeConstraints { [weak self] make in
            if let _ = self {
                make.top.equalTo(20.0)
                make.leading.equalTo(20.0)
                make.trailing.equalTo(-20.0)
            }
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
}

class LocationCell: UICollectionViewCell {
    let bgView = UIView()
    let titleLabel = UILabel()
    let clearButton = UIButton()
    var clearCallback: ((Void) -> ())?

    func commonInit() {

        addSubview(bgView)
        bgView.backgroundColor = UIColor.whiteColor()
        bgView.layer.borderColor = UIColor.darkGrayColor().CGColor
        bgView.layer.borderWidth = 1.0 / UIScreen.mainScreen().scale
        bgView.snp_makeConstraints { [weak self] make in
            if let _ = self {
                make.top.equalTo(-1)
                make.leading.equalTo(0)
                make.trailing.equalTo(0)
                make.bottom.equalTo(0)
            }
        }

        addSubview(titleLabel)
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        titleLabel.textColor = UIColor.darkGrayColor()
        titleLabel.snp_makeConstraints { [weak self] make in
            if let _ = self {
                make.top.equalTo(0)
                make.leading.equalTo(20.0)
                make.trailing.equalTo(-20.0)
                make.bottom.equalTo(0)
            }
        }

        addSubview(clearButton)
        clearButton.setTitle("X", forState: .Normal)
        clearButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        clearButton.addTarget(self, action: "clearButtonTapped:", forControlEvents: .TouchUpInside)
        clearButton.snp_makeConstraints { [weak self] make in
            if let _ = self {
                make.top.equalTo(0)
                make.trailing.equalTo(-4.0)
                make.bottom.equalTo(0)
                make.width.equalTo(44.0)
            }
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

    func clearButtonTapped(sender: UIButton) {
        clearCallback?()
    }
}

class LocationsHeader: UICollectionReusableView {
    var backgroundView = UIView()
    var titleLabel: UILabel = UILabel()
    var addButton: UIButton = UIButton()
    var addCallback: ((Void) -> ())?
    func commonInit() {

        backgroundColor = UIColor.clearColor()

        addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.whiteColor()
        backgroundView.layer.borderColor = UIColor.darkGrayColor().CGColor
        backgroundView.layer.borderWidth = 1.0 / UIScreen.mainScreen().scale
        backgroundView.snp_makeConstraints { [weak self] make in
            if let _ = self {
                make.top.equalTo(0)
                make.leading.equalTo(20.0)
                make.bottom.equalTo(0)
                make.trailing.equalTo(-20.0)
            }
        }

        addSubview(titleLabel)
        titleLabel.text = "Locations"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.snp_makeConstraints { [weak self] make in
            if let _ = self {
                make.top.equalTo(0)
                make.leading.equalTo(20.0)
                make.bottom.equalTo(0)
                make.trailing.equalTo(-20.0)
            }
        }

        addSubview(addButton)
        addButton.setTitle("Add", forState: .Normal)
        addButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12.0)
        addButton.addTarget(self, action: "addButtonTapped:", forControlEvents: .TouchUpInside)
        addButton.snp_makeConstraints { [weak self] make in
            if let _ = self {
                make.width.equalTo(40.0)
                make.top.equalTo(0)
                make.trailing.equalTo(-30)
                make.bottom.equalTo(0)
            }
        }
    }

    func addButtonTapped(sender: UIButton) {
        addCallback?()
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

protocol SearchFiltersViewInterface {

}

class SearchFiltersViewController: UIViewController, SearchFiltersViewInterface, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var saveCallback: ((SearchFilters) -> ())?
    var cancelCallback: ((Void) -> ())?
    var searchFilters = SearchFilters()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = "Search Filters"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelButtonTapped:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonTapped:")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func cancelButtonTapped(sender: AnyObject) {
        cancelCallback?()
    }

    func saveButtonTapped(sender: AnyObject) {
        saveCallback?(searchFilters)
    }
    
    func earliestDateCellTapped() {
        let vc = DatePickerViewController(
            latestPossibleDate: searchFilters.latestDate ?? SearchParameters.latestPossibleDate(),
            selectedDateOnInit: searchFilters.earliestDate)
        vc.saveCallback = { [weak self] selectedDate in
            self?.searchFilters.earliestDate = selectedDate
            self?.collectionView.reloadData()
            self?.navigationController?.popViewControllerAnimated(true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func latestDateCellTapped() {
        let vc = DatePickerViewController(
            earliestPossibleDate: searchFilters.earliestDate ?? SearchParameters.earliestPossibleDate(),
            selectedDateOnInit: searchFilters.latestDate ?? SearchParameters.latestPossibleDate())
        vc.saveCallback = { [weak self] selectedDate in
            self?.searchFilters.latestDate = selectedDate
            self?.collectionView.reloadData()
            self?.navigationController?.popViewControllerAnimated(true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func locationsCellTapped() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerClass(LocationsHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.registerClass(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        collectionView.registerClass(EmptyLocationCell.self, forCellWithReuseIdentifier: "EmptyLocationCell")
        collectionView.registerClass(LocationCell.self, forCellWithReuseIdentifier: "LocationCell")
    }

    // MARK: UICollectionViewDelegate methods

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            earliestDateCellTapped()
        case 1:
            latestDateCellTapped()
        case 2:
            if searchFilters.cities == nil {
                locationsCellTapped()
            }
        default:
            break
        }
    }

    // MARK: UICollectionViewDataSource overrides

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! LocationsHeader
        header.addCallback = { [weak self] in
            self?.locationsCellTapped()
        }
        return header
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            if searchFilters.cities == nil {
                return 1
            } else {
                return (searchFilters.cities?.count ?? 0)
            }
        default:
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

//        let formatString = "MMM dd, yyyy"

        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
            cell.titleLabel.text = "Earliest Date"
            if let _ = searchFilters.earliestDate {
//                cell.subtitleLabel.text = moment(earliestDate).format(dateFormat: formatString)
            } else {
                cell.subtitleLabel.text = "--"
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
            cell.titleLabel.text = "Latest Date"
            if let _ = searchFilters.latestDate {
//                cell.subtitleLabel.text = moment(latestDate).format(dateFormat: formatString)
            } else {
                cell.subtitleLabel.text = "--"
            }
            return cell
        case 2:
            if let cities = searchFilters.cities {

                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LocationCell", forIndexPath: indexPath) as! LocationCell
                let city = cities[indexPath.row]
                cell.titleLabel.text = "\(city.name), \(city.stateName.abbreviation)"
                cell.clearCallback = { [weak self] in
                    self?.searchFilters.cities?.removeAtIndex(indexPath.row)
                    self?.collectionView.reloadData()
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EmptyLocationCell", forIndexPath: indexPath) as! EmptyLocationCell
                return cell
            }
        default:
            break
        }
        return UICollectionViewCell()
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return (section == 2) ? CGSize(width: collectionView.frame.size.width - 20.0, height: 44) : CGSizeZero
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        case 1:
            return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        case 2:
            return UIEdgeInsets(top: -(1.0/UIScreen.mainScreen().scale), left: 20, bottom: 20, right: 20)
        default:
            return UIEdgeInsetsZero
        }
    }

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            switch indexPath.section {
            case 0:
                return CGSize(width: collectionView.bounds.size.width - 40.0, height: 66.0)
            case 1:
                return CGSize(width: collectionView.bounds.size.width - 40.0, height: 66.0)
            case 2:
                return CGSize(width: collectionView.bounds.size.width - 40.0, height: 44.0)
            default:
                return CGSizeZero
            }

    }
}
