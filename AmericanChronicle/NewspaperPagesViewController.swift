//
//  DetailViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

extension UIView {
    func addForAutolayout(subview: UIView) {
        subview.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(subview)
    }
}

class NewspaperPagesViewController: UIViewController, UICollectionViewDelegate, NewspaperPagesPreviewActionHandler {

    @IBOutlet weak var previewCollectionView: UICollectionView!
    @IBOutlet weak var stripCollectionView: UICollectionView!
    @IBOutlet var previewDelegate: NewspaperPagesPreviewDelegate!
    @IBOutlet var dataSource: NewspaperPagesDataSource!
    @IBOutlet weak var stripCollectionViewBottom: NSLayoutConstraint!

    var issue: NewspaperIssue? {
        didSet {
            if !isViewLoaded() {
                return
            }
            previewDelegate.issue = issue
        }
    }

    @IBAction func pageTapRecognized(sender: UITapGestureRecognizer) {
        println("pageTapRecongnized - stripCollectionViewBottom.constant: \(stripCollectionViewBottom.constant)")
        if stripCollectionViewBottom.constant == 0 {
            hideStrip()
        } else {
            showStrip()
        }
    }

    func showStrip() {
        stripCollectionViewBottom.constant = 0
        UIView.animateWithDuration(0.3, animations: {
            println("showStrip animating")
            self.view.layoutIfNeeded()
        }, completion: { finished in
            println("showStrip finished: \(finished)")
        })
    }

    func hideStrip() {
        stripCollectionViewBottom.constant = -stripCollectionView.frame.size.height
        UIView.animateWithDuration(0.3, animations: {
            println("hideStrip animating")
            self.view.layoutIfNeeded()
        }, completion: { finished in
            println("hideStrip finished: \(finished)")
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        previewDelegate.issue = issue
        previewDelegate.actionHandler = self

        dataSource.issue = issue
        dataSource.didZoomCallback = { [weak self] scrollView in
//            println("scrollView.zoomScale: \(scrollView.zoomScale)")
//            if scrollView.zoomScale <= 1.0 {
//                self?.showStrip()
//            } else {
//                self?.hideStrip()
//            }
        }
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

