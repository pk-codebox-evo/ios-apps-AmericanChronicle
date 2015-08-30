//
//  DetailViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperIssuesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var newspaper: Newspaper?

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newspaper?.issues.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! NewspaperIssueCell
        cell.title = newspaper?.issues[indexPath.row].description
        cell.image = UIImage(named: newspaper?.issues[indexPath.row].imageName ?? "")
        println("newspaper?.issues[indexPath.row].imageName: \(newspaper?.issues[indexPath.row].imageName)")
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (self.view.bounds.size.width - 30) / 2.0
        return CGSize(width: width, height: width * 1.5)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nvc = segue.destinationViewController as? UINavigationController,
            let vc = nvc.viewControllers.first as? SearchViewController {
                vc.filters = SearchFilters()
                if let city = newspaper?.city {
                    vc.filters?.cities = [city]
                }
        } else if let vc = segue.destinationViewController as? NewspaperPagesViewController,
            let selectedPath = collectionView.indexPathsForSelectedItems().first as? NSIndexPath {
            vc.issue = newspaper?.issues[selectedPath.item]
        }
    }
}

