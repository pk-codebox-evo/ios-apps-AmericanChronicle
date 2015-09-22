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
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
}

class CustomLayout: UICollectionViewFlowLayout {

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
        if chromeHidden {
            showStrip()
        } else {
            hideStrip()
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return chromeHidden
    }

    var chromeHidden = false

    func showStrip() {
        chromeHidden = false
        stripCollectionViewBottom.constant = 0

        UIView.animateWithDuration(0.3, animations: {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.view.layoutIfNeeded()

        }, completion: { finished in
        })
    }

    func hideStrip() {

        stripCollectionViewBottom.constant = -stripCollectionView.frame.size.height

        UIView.animateWithDuration(0.3, animations: {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.view.layoutIfNeeded()
            self.chromeHidden = true
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: { finished in
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: "pageTapRecognized:")
        view.addGestureRecognizer(tap)
//        navigationController?.hidesBarsOnTap = true
//        navigationController?.barHideOnTapGestureRecognizer.addTarget(self, action: "pageTapRecognized:")

        previewDelegate.issue = issue
        previewDelegate.actionHandler = self

        dataSource.issue = issue
        stripCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .Left)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
//        if let vc = segue.destinationViewController as? PageViewController,
//        let selectedPath = previewCollectionView.indexPathsForSelectedItems()!.first {
//
//            vc.imageName = issue?.pages[selectedPath.item].imageName
//            vc.doneCallback = { [unowned self] in
//
//                let segue = NewspaperPageUnfocusSegue(identifier: nil, source: vc, destination: self)
//                segue.perform()
//            }
//        }
    }
}

