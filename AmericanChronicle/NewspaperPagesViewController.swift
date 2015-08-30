//
//  DetailViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperPagesViewController: UIViewController, UICollectionViewDelegate, NewspaperPagesPreviewActionHandler {

    @IBOutlet weak var previewCollectionView: UICollectionView!
    @IBOutlet weak var stripCollectionView: UICollectionView!
    @IBOutlet var previewDelegate: NewspaperPagesPreviewDelegate!
    @IBOutlet var dataSource: NewspaperPagesDataSource!
    var issue: NewspaperIssue? {
        didSet {
            if !isViewLoaded() {
                return
            }
            println("\(__FILE__) | \(__FUNCTION__) | line \(__LINE__)")
            previewDelegate.issue = issue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        previewDelegate.issue = issue
        previewDelegate.actionHandler = self

        dataSource.issue = issue
        stripCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .Left)
    }


    func didScrollToPreviewAtIndexPath(indexPath: NSIndexPath) {
        stripCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
    }

    // MARK: UICollectionViewDelegate methods

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        previewCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)

    }

    @IBAction func unfocusPage(sender: UIStoryboardSegue) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? PageViewController,
        let selectedPath = previewCollectionView.indexPathsForSelectedItems().first as? NSIndexPath {

            vc.imageName = issue?.pages[selectedPath.item].imageName
            vc.doneCallback = { [unowned self] in

                let segue = NewspaperPageUnfocusSegue(identifier: nil, source: vc, destination: self)
                segue.perform()
            }
        }
    }
}

