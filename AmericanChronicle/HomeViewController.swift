//
//  HomeViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import SwiftMoment

class HomeViewController: UITableViewController {

    var statesByName = [StateName: State]()

    override func awakeFromNib() {
        super.awakeFromNib()

        statesByName[.Alabama] = {
            var selma = City(name: "Selma", lat: 0, lng: 0, stateName: .Alabama, newspapers: [])
            selma.newspapers.append(Newspaper(title: "Chattanooga daily rebel.", city: selma, startYear: 1865, endYear: 1865, issues: []))

            return State(name: .Alabama, lat: 0, lng: 0, cities: [selma])
        }()

        statesByName[.Arizona] = {
            var holbrook = City(name: "Holbrook", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            let holbrookIssues = [
                NewspaperIssue(date: moment([1902, 10, 02])!)
            ]
            holbrook.newspapers.append(Newspaper(title: "The argus", city: holbrook, startYear: 1895, endYear: 1900, issues: holbrookIssues))

            var peachSprings = City(name: "Peach Springs", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            let peachSpringsIssues = [NewspaperIssue(date: moment([1902, 10, 02])!)]
            peachSprings.newspapers.append(Newspaper(title: "The Arizona champion", city: peachSprings, startYear: 1883, endYear: 1891, issues: peachSpringsIssues))

            var tucson = City(name: "Tucson", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])

            let tucsonIssues = [
                NewspaperIssue(date: moment([1870, 10, 17])!),
                NewspaperIssue(date: moment([1870, 10, 22])!),
                NewspaperIssue(date: moment([1870, 10, 29])!),
                NewspaperIssue(date: moment([1870, 11, 05])!)
            ]
            tucson.newspapers.append(Newspaper(title: "Arizona citizen", city: tucson, startYear: 1870, endYear: 1880, issues: tucsonIssues))

            var bisbee = City(name: "Bisbee", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            let bisbeeIssues = [NewspaperIssue(date: moment([1902, 10, 02])!)]
            bisbee.newspapers.append(Newspaper(title: "The Arizona daily orb", city: bisbee, startYear: 1898, endYear: 1900, issues: bisbeeIssues))

            var tombstone = City(name: "Tombstone", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            let tombstoneIssues = [NewspaperIssue(date: moment([1902, 10, 02])!)]
            tombstone.newspapers.append(Newspaper(title: "The Arizona kicker", city: tombstone, startYear: 1893, endYear: 1913, issues: tombstoneIssues))

            var fortWhipple = City(name: "Fort Whipple", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            let fortWhippleIssues = [NewspaperIssue(date: moment([1902, 10, 02])!)]
            fortWhipple.newspapers.append(Newspaper(title: "Arizona miner", city: fortWhipple, startYear: 1864, endYear: 1868, issues: fortWhippleIssues))

            var phoenix = City(name: "Phoenix", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            let phoenixIssues = [NewspaperIssue(date: moment([1902, 10, 02])!)]
            phoenix.newspapers.append(Newspaper(title: "Arizona republican", city: phoenix, startYear: 1890, endYear: 1930, issues: phoenixIssues))

            var williams = City(name: "Williams", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            let williamsIssues = [NewspaperIssue(date: moment([1902, 10, 02])!)]
            williams.newspapers.append(Newspaper(title: "Williams news.", city: williams, startYear: 1901, endYear: 1922, issues: williamsIssues))

            return State(name: .Arizona, lat: 0, lng: 0, cities: [holbrook, peachSprings, tucson, bisbee, tombstone, fortWhipple, phoenix, williams])
        }()


        statesByName[.Arkansas] = {
            var holbrook = City(name: "Holbrook", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            var paper = Newspaper(title: "The argus", city: holbrook, startYear: 1895, endYear: 1900, issues: [])
            holbrook.newspapers.append(paper)
            return State(name: .Arkansas, lat: 0, lng: 0, cities: [holbrook])
        }()
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

