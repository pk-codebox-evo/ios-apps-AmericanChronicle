//
//  DetailViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperIssuesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var newspaper: Newspaper? {
        didSet {
            navigationItem.title = newspaper?.title

            if !isViewLoaded() {
                return
            }

            collectionView.reloadData()
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.Search.rawValue:
            return 1
        case Section.Thumbnail.rawValue:
            return newspaper?.issues.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Section.Search.rawValue:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SearchCell", forIndexPath: indexPath) as! SearchFieldCell
            let fallbackText = "this newspaper"
            cell.searchField.placeholder = "Search \(newspaper?.title ?? fallbackText)"
            cell.searchField.shouldBeginEditingCallback = { [weak self] in
                let sb = UIStoryboard(name: "Search", bundle: nil)
                if let nvc = sb.instantiateInitialViewController() as? UINavigationController,
                    let vc = nvc.topViewController as? SearchViewController {
                        vc.filters = SearchFilters()
                        if let city = self?.newspaper?.city {
                            vc.filters?.cities = [city]
                        }
//                        vc.cancelCallback = { [weak self] in
//                            self?.dismissViewControllerAnimated(true, completion: nil)
//                        }
                        nvc.modalPresentationStyle = .Custom
                        nvc.transitioningDelegate = self
                        self?.presentViewController(nvc, animated: true, completion: nil)
                }
                return false
            }
            return cell
        case Section.Thumbnail.rawValue:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! NewspaperIssueCell
//            cell.title = newspaper?.issues[indexPath.row].description
//            cell.image = UIImage(named: newspaper?.issues[indexPath.row].imageName ?? "")
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch indexPath.section {
        case Section.Search.rawValue:
            return CGSize(width: self.view.bounds.size.width, height: 64.0)
        case Section.Thumbnail.rawValue:
            let width = (self.view.bounds.size.width - 30) / 2.0
            return CGSize(width: width, height: width * 1.5)
        default:
            return CGSizeZero
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch section {
        case Section.Search.rawValue:
            return UIEdgeInsetsZero
        case Section.Thumbnail.rawValue:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        default:
            return UIEdgeInsetsZero
        }
    }

    enum Section: Int {
        case Search = 0
        case Thumbnail = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nvc = segue.destinationViewController as? UINavigationController,
            let vc = nvc.viewControllers.first as? SearchViewController {
                vc.filters = SearchFilters()
                if let city = newspaper?.city {
                    vc.filters?.cities = [city]
                }
        } else if let vc = segue.destinationViewController as? NewspaperPagesViewController,
            let selectedPath = collectionView.indexPathsForSelectedItems()?.first {
            vc.issue = newspaper?.issues[selectedPath.item]
        }
    }

    // MARK: UIViewControllerTransitioningDelegate methods

    func animationControllerForPresentedController(presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return TransitionController()
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionController()
    }
}

