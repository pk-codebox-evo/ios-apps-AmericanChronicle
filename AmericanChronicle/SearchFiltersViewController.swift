//
//  SearchFiltersViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/11/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import SwiftMoment
import FSCalendar
import SnapKit

extension UIViewController {
    func setChildViewController(viewController : UIViewController, inContainer containerView: UIView) {
        if let onlyChild = self.childViewControllers.first as? UIViewController {
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
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1.0

        addSubview(titleLabel)
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        titleLabel.textColor = UIColor.lightGrayColor()

        titleLabel.snp_makeConstraints { [weak self] make in
            if let myself = self {
                make.top.equalTo(20.0)
                make.leading.equalTo(20.0)
                make.trailing.equalTo(-20.0)
            }
        }

        addSubview(subtitleLabel)
        subtitleLabel.text = "This is subtitle"
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        subtitleLabel.textColor = UIColor.blueColor()

        subtitleLabel.snp_makeConstraints { [weak self] make in
            if let myself = self {
                make.top.equalTo(myself.titleLabel.snp_bottom)
                make.leading.equalTo(20.0)
                make.trailing.equalTo(-20.0)
            }
        }
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
}

class SearchFiltersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

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

    required init(coder aDecoder: NSCoder) {
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
            latestPossibleDate: searchFilters.latestDate ?? ChroniclingAmericaArchive.latestPossibleDate,
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
            earliestPossibleDate: searchFilters.earliestDate ?? ChroniclingAmericaArchive.earliestPossibleDate,
            selectedDateOnInit: searchFilters.latestDate ?? ChroniclingAmericaArchive.latestPossibleDate)
        vc.saveCallback = { [weak self] selectedDate in
            self?.searchFilters.latestDate = selectedDate
            self?.collectionView.reloadData()
            self?.navigationController?.popViewControllerAnimated(true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func locationsCellTapped() {
        let vc = LocationSearchViewController(nibName: "LocationSearchViewController", bundle: nil)
        vc.locationSelectedCallback = { [weak self] location in
            var locations = self?.searchFilters.locations ?? []
            locations.append(location)
            self?.searchFilters.locations = locations
            self?.collectionView.reloadData()
            self?.navigationController?.popViewControllerAnimated(true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerClass(FilterCell.self, forCellWithReuseIdentifier: "Cell")
    }

    // MARK: UICollectionViewDelegate methods

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            earliestDateCellTapped()
        case 1:
            latestDateCellTapped()
        case 2:
            locationsCellTapped()
        default:
            break
        }
    }

    // MARK: UICollectionViewDataSource overrides

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FilterCell

        let formatString = "MMM dd, yyyy"

        switch indexPath.section {
        case 0:
            cell.titleLabel.text = "Earliest Date"
            if let earliestDate = searchFilters.earliestDate {
                cell.subtitleLabel.text = moment(earliestDate).format(dateFormat: formatString)
            } else {
                cell.subtitleLabel.text = "--"
            }
        case 1:
            cell.titleLabel.text = "Latest Date"
            if let latestDate = searchFilters.latestDate {
                cell.subtitleLabel.text = moment(latestDate).format(dateFormat: formatString)
            } else {
                cell.subtitleLabel.text = "--"
            }
        case 2:
            cell.titleLabel.text = "Locations"
            if searchFilters.locations?.count == 0 {
                cell.subtitleLabel.text = "Anywhere"
            } else if searchFilters.locations?.count == 1 {
                cell.subtitleLabel.text = "1 Location"
            } else {
                cell.subtitleLabel.text = "\(searchFilters.locations?.count ?? 0) Locations"
            }
        default:
            break
        }

        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.size.width - 20.0, height: 80.0)
    }
}
