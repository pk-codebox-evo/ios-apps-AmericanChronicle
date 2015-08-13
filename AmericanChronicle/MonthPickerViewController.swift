//
//  MonthPickerViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/12/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

enum Month: Int {
    case January
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
    static func stringForRawValue(rawValue: Int) -> String {
        let month = Month(rawValue: rawValue) ?? .January
        switch month {
        case .January:
            return "January"
        case .February:
            return "February"
        case .March:
            return "March"
        case .April:
            return "April"
        case .May:
            return "May"
        case .June:
            return "June"
        case .July:
            return "July"
        case .August:
            return "August"
        case .September:
            return "September"
        case .October:
            return "October"
        case .November:
            return "November"
        case .December:
            return "December"
        }
    }
}

@objc class MonthPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedMonth: Month = .January
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backdropHeight: NSLayoutConstraint!
    @IBOutlet weak var backdropView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.selectRowAtIndexPath(NSIndexPath(forItem: selectedMonth.rawValue, inSection: 0), animated: false, scrollPosition: .Top)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var didSelectMonthCallback: ((Month) -> Void)?

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.cellForRowAtIndexPath(NSIndexPath(forItem: selectedMonth.rawValue, inSection: 0))?.accessoryType = UITableViewCellAccessoryType.None
        selectedMonth = Month(rawValue: indexPath.item) ?? .January
        tableView.cellForRowAtIndexPath(NSIndexPath(forItem: selectedMonth.rawValue, inSection: 0))?.accessoryType = UITableViewCellAccessoryType.Checkmark
        didSelectMonthCallback?(selectedMonth)
    }

    // MARK: UITableViewDataSource methods {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        cell.textLabel?.text = Month.stringForRawValue(indexPath.row)
        return cell
    }

//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return nil
//    }
//
//    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return nil
//    }
//
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false
//    }
//
//    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false
//    }
//
//    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
//    }
//
//    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
//        return 0
//    }
//
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//    }
//
//    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//    }
}
