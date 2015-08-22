//
//  HomeViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    var newspapers = [StateName: [Newspaper]]()

    override func awakeFromNib() {
        super.awakeFromNib()

        newspapers[.Alabama] = [
            Newspaper(title: "Chattanooga daily rebel.", city: "Selma", startYear: 1865, endYear: 1865)
        ]
        newspapers[.Arizona] = [
            Newspaper(title: "The argus", city: "Holbrook", startYear: 1895, endYear: 1900),
            Newspaper(title: "The Arizona champion", city: "Peach Springs", startYear: 1883, endYear: 1891),
            Newspaper(title: "Arizona citizen", city: "Tucson", startYear: 1870, endYear: 1880),
            Newspaper(title: "The Arizona daily orb", city: "Bisbee", startYear: 1898, endYear: 1900),
            Newspaper(title: "The Arizona kicker", city: "Tombstone", startYear: 1893, endYear: 1913),
            Newspaper(title: "Arizona miner", city: "Fort Whipple", startYear: 1864, endYear: 1868),
            Newspaper(title: "Arizona republican", city: "Phoenix", startYear: 1890, endYear: 1930),
            Newspaper(title: "Williams news.", city: "Williams", startYear: 1901, endYear: 1922)
        ]
        newspapers[.Arkansas] = [Newspaper(title: "The argus", city: "Holbrook", startYear: 1895, endYear: 1900)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func newspaperAtIndexPath(indexPath: NSIndexPath) -> Newspaper? {
        if let papers = newspapers[StateName.alphabeticalList[indexPath.section]] {
            return papers[indexPath.row]
        }
        return nil
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
        return newspapers.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let papers = newspapers[StateName.alphabeticalList[section]] {
            return papers.count
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
            cell.detailTextLabel?.text = paper.city
        } else {
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = nil
        }

        return cell
    }
}

