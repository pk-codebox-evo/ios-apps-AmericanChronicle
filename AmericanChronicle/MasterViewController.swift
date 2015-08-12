//
//  MasterViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    enum State: Int {
        case Alabama
        case Arizona
        case Arkansas

        var description: String {
            switch self {
            case .Alabama: return "Alabama"
            case .Arizona: return "Arizona"
            case .Arkansas: return "Arkansas"
            }
        }
    }

    class Newspaper {
        let title: String
        let city: String
        var startYear: Int?
        var endYear: Int?

        init(title: String, city: String, startYear: Int?, endYear: Int?) {
            self.title = title
            self.city = city
            self.startYear = startYear
            self.endYear = endYear
        }

        var description: String {
            return title
        }
    }

    var newspapers = [State: [Newspaper]]()

    override func awakeFromNib() {
        super.awakeFromNib()

        newspapers[.Alabama] = [Newspaper(title: "Chattanooga daily rebel.", city: "Selma", startYear: 1865, endYear: 1865)]
        newspapers[.Arizona] = [
            Newspaper(title: "The argus", city: "Holbrook", startYear: 1895, endYear: 1900),
            Newspaper(title: "The Arizona champion", city: "Peach Springs", startYear: 1883, endYear: 1891),
            Newspaper(title: "Arizona citizen", city: "Tucson", startYear: 1870, endYear: 1880),
            Newspaper(title: "The Arizona daily orb", city: "Bisbee", startYear: 1898, endYear: 1900),
            Newspaper(title: "The Arizona kicker", city: "Tombstone", startYear: 1893, endYear: 1913),
            Newspaper(title: "Arizona miner", city: "Fort Whipple", startYear: 1864, endYear: 1868),
            Newspaper(title: "Arizona republican", city: "Phoenix", startYear: 1890, endYear: 1930)
        ]
        newspapers[.Arkansas] = [Newspaper(title: "The argus", city: "Holbrook", startYear: 1895, endYear: 1900)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func newspaperAtIndexPath(indexPath: NSIndexPath) -> Newspaper? {
        if let state = State(rawValue: indexPath.section), let papers = newspapers[state] {
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
        // Disable browsing
        return 0; // newspapers.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let state = State(rawValue: section) {
            return newspapers[state]?.count ?? 0
        }
        return 0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let state = State(rawValue: section) {
            return state.description
        }
        return "(Unknown)"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        if let paper = newspaperAtIndexPath(indexPath) {
            cell.textLabel?.text = paper.title
        } else {
            cell.textLabel?.text = nil
        }
        return cell
    }
}

