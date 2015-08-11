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
    var hidesStatusBar: Bool = false

    var newspaper: AnyObject? {
        didSet {
        }
    }

    func prepareForDisappearanceAnimation() {
//        hidesStatusBar = true
//        setNeedsStatusBarAppearanceUpdate()
    }

    func updateViewsInsideDisappearanceAnimation() {

//        navigationController?.setNavigationBarHidden(true, animated: false)

    }

    func prepareForAppearanceAnimation() {

    }

    func updateViewsInsideAppearanceAnimation() {

//        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func cleanUpAfterAppearanceAnimation() {
//        hidesStatusBar = false
//        setNeedsStatusBarAppearanceUpdate()
    }

    override func prefersStatusBarHidden() -> Bool {
        return hidesStatusBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        previewDelegate.actionHandler = self
        stripCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .Left)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func didScrollToPreviewAtIndexPath(indexPath: NSIndexPath) {
        stripCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
    }

    // MARK: UICollectionViewDelegate methods

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        previewCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)

    }

    @IBAction func unfocusPage(sender: UIStoryboardSegue) {
        println("\(__FILE__) | \(__FUNCTION__) | line \(__LINE__)")
    }
}

