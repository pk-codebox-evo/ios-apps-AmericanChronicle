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

class FilterButton: UIButton {
    let subtitleLabel: UILabel = UILabel()

    func commonInit() {
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1.0
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)

        titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        setTitleColor(UIColor.lightGrayColor(), forState: .Normal)

        addSubview(subtitleLabel)
        subtitleLabel.text = "This is subtitle"
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        subtitleLabel.textColor = UIColor.blueColor()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    override func updateConstraints() {

        subtitleLabel.snp_makeConstraints { [weak self] make in
            if let myself = self {
                make.bottom.equalTo(-20.0)
                make.leading.equalTo(20.0)
                make.trailing.equalTo(-20.0)
            }
        }

        super.updateConstraints()
    }
}

class SearchFiltersViewController: UIViewController {

    var searchFilters: SearchFilters = SearchFilters()

    @IBOutlet weak var earliestDateButton: FilterButton!
    @IBOutlet weak var latestDateButton: FilterButton!
    @IBOutlet weak var locationButton: FilterButton!



    @IBAction func earliestDateButtonTapped(sender: AnyObject) {
        let vc = DatePickerViewController(
            latestPossibleDate: searchFilters.latestDate ?? ChroniclingAmericaArchive.latestPossibleDate,
            selectedDateOnInit: searchFilters.earliestDate)
        vc.saveCallback = { [weak self] selectedDate in
            self?.searchFilters.earliestDate = selectedDate
            self?.updateFilterButtons()
            self?.navigationController?.popViewControllerAnimated(true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func latestDateButtonTapped(sender: AnyObject) {
        let vc = DatePickerViewController(
            earliestPossibleDate: searchFilters.earliestDate ?? ChroniclingAmericaArchive.earliestPossibleDate,
            selectedDateOnInit: searchFilters.latestDate)
        vc.saveCallback = { [weak self] selectedDate in
            self?.searchFilters.latestDate = selectedDate
            self?.updateFilterButtons()
            self?.navigationController?.popViewControllerAnimated(true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func updateFilterButtons() {
        let formatString = "MMM dd, yyyy"
        if let earliestDate = self.searchFilters.earliestDate {
            earliestDateButton.subtitleLabel.text = moment(earliestDate).format(dateFormat: formatString)
        } else {
            earliestDateButton.subtitleLabel.text = "--"
        }

        if let latestDate = self.searchFilters.latestDate {
            latestDateButton.subtitleLabel.text = moment(latestDate).format(dateFormat: formatString)
        } else {
            latestDateButton.subtitleLabel.text = "--"
        }

        if let locations = self.searchFilters.locations {
            locationButton.subtitleLabel.text = "\(locations.count) locations set"
        } else {
            locationButton.subtitleLabel.text = "--"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateFilterButtons()

    }
}
