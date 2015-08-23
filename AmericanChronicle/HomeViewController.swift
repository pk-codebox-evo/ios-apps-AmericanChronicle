//
//  HomeViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    var statesByName = [StateName: State]()

    override func awakeFromNib() {
        super.awakeFromNib()

        statesByName[.Alabama] = {
            var selma = City(name: "Selma", lat: 0, lng: 0, stateName: .Alabama, newspapers: [])
            selma.newspapers.append(Newspaper(title: "Chattanooga daily rebel.", city: selma, startYear: 1865, endYear: 1865))

            return State(name: .Alabama, lat: 0, lng: 0, cities: [selma])
        }()

        statesByName[.Arizona] = {
            var holbrook = City(name: "Holbrook", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            holbrook.newspapers.append(Newspaper(title: "The argus", city: holbrook, startYear: 1895, endYear: 1900))

            var peachSprings = City(name: "Peach Springs", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            peachSprings.newspapers.append(Newspaper(title: "The Arizona champion", city: peachSprings, startYear: 1883, endYear: 1891))

            var tucson = City(name: "Tucson", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            tucson.newspapers.append(Newspaper(title: "Arizona citizen", city: tucson, startYear: 1870, endYear: 1880))

            var bisbee = City(name: "Bisbee", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            bisbee.newspapers.append(Newspaper(title: "The Arizona daily orb", city: bisbee, startYear: 1898, endYear: 1900))

            var tombstone = City(name: "Tombstone", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            tombstone.newspapers.append(Newspaper(title: "The Arizona kicker", city: tombstone, startYear: 1893, endYear: 1913))

            var fortWhipple = City(name: "Fort Whipple", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            fortWhipple.newspapers.append(Newspaper(title: "Arizona miner", city: fortWhipple, startYear: 1864, endYear: 1868))

            var phoenix = City(name: "Phoenix", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            phoenix.newspapers.append(Newspaper(title: "Arizona republican", city: phoenix, startYear: 1890, endYear: 1930))

            var williams = City(name: "Williams", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            williams.newspapers.append(Newspaper(title: "Williams news.", city: williams, startYear: 1901, endYear: 1922))

            return State(name: .Arizona, lat: 0, lng: 0, cities: [holbrook, peachSprings, tucson, bisbee, tombstone, fortWhipple, phoenix, williams])
        }()


        statesByName[.Arkansas] = {
            var holbrook = City(name: "Holbrook", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
            var paper = Newspaper(title: "The argus", city: holbrook, startYear: 1895, endYear: 1900)
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

