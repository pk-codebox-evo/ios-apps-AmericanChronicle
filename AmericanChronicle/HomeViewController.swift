//
//  HomeViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit


class HomeViewController: UITableViewController {

    var statesByName = FakeData.statesByName()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func newspaperAtIndexPath(indexPath: NSIndexPath) -> Newspaper? {
        if let state = statesByName[StateName.alphabeticalList[indexPath.section]] {
            return state.newspapers[indexPath.row]
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow(), let paper = newspaperAtIndexPath(indexPath) {
                (segue.destinationViewController as! NewspaperIssuesViewController).newspaper = paper
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return statesByName.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let state = statesByName[StateName.alphabeticalList[section]] {
            return state.newspapers.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return StateName.alphabeticalList[section].rawValue
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        if let paper = newspaperAtIndexPath(indexPath) {
            cell.textLabel?.text = paper.title
            cell.detailTextLabel?.text = paper.city.name
        } else {
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = nil
        }

        return cell
    }
}

