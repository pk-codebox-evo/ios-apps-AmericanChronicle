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

class DateButton: UIButton {
    let subtitleLabel: UILabel = UILabel()

    func commonInit() {
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1.0
        addSubview(subtitleLabel)
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
        
        super.updateConstraints()
    }
}

class SearchFiltersViewController: UIViewController {

    var searchFilters: SearchFilters = SearchFilters()

    @IBOutlet weak var earliestDateButton: UIButton!
    @IBOutlet weak var latestDateButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!


    @IBAction func earliestDateButtonTapped(sender: AnyObject) {
        let vc = DatePickerViewController()
        vc.saveCallback = { [weak self] selectedDate in
            self?.searchFilters.earliestDate = selectedDate
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func latestDateButtonTapped(sender: AnyObject) {
        let vc = DatePickerViewController()
        vc.saveCallback = { [weak self] selectedDate in
            self?.searchFilters.latestDate = selectedDate
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
