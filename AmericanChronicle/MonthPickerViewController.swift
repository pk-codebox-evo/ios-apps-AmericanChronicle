//
//  MonthPickerViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/12/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

@objc class MonthPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedMonth: Month?
    var didSelectMonthCallback: ((Month?) -> Void)?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backdropHeight: NSLayoutConstraint!
    @IBOutlet weak var backdropView: UIView!

    @IBAction func tapRecognized(sender: AnyObject) {
        didSelectMonthCallback?(nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let month = selectedMonth {
            let indexPath = NSIndexPath(forItem: month.rawValue, inSection: 0)

        }
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let month = selectedMonth {
            tableView.cellForRowAtIndexPath(NSIndexPath(forItem: month.rawValue, inSection: 0))?.accessoryType = .None
        }
        selectedMonth = Month(rawValue: indexPath.item)
        if let month = selectedMonth {
            tableView.cellForRowAtIndexPath(NSIndexPath(forItem: month.rawValue, inSection: 0))?.accessoryType = .Checkmark
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        didSelectMonthCallback?(selectedMonth)
    }

    // MARK: UITableViewDataSource methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        if let selectedRow = selectedMonth?.rawValue where selectedRow == indexPath.row {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        cell.textLabel?.text = Month.stringForRawValue(indexPath.row)
        return cell
    }
}
