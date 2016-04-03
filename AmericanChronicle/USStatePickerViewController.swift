//
//  USStatePickerViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/13/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

protocol USStatePickerViewInterface {
    var delegate: USStatePickerViewDelegate? { get set }
    var states: [String] { get set }
    func setSelectedStateNames(selectedStates: [String])
}

protocol USStatePickerViewDelegate {
    func userDidTapSave(selectedStateNames: [String])
    func userDidTapCancel()
}

class USStateCell: UICollectionViewCell {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.whiteColor()
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Colors.lightBlueBright
        label.textAlignment = .Center
        label.font = Font.largeBody
        label.frame = self.bounds
        label.highlightedTextColor = UIColor.whiteColor()
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private let reuseIdentifier = "Cell"

class USStatePickerViewController: UICollectionViewController, USStatePickerViewInterface {

    var delegate: USStatePickerViewDelegate?

    var states: [String] = []
    func setSelectedStateNames(selectedStates: [String]) {
        for selectedState in selectedStates {
            if let idx = states.indexOf(selectedState) {
                collectionView?.selectItemAtIndexPath(
                    NSIndexPath(forItem: idx, inSection: 0),
                    animated: false,
                    scrollPosition: UICollectionViewScrollPosition.None)
            }

        }
    }

    convenience init() {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        navigationItem.title = "U.S. States"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(USStatePickerViewController.didTapCancelButton(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(USStatePickerViewController.didTapSaveButton(_:)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.registerClass(USStateCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.allowsMultipleSelection = true
        collectionView?.backgroundColor = Colors.lightBackground.colorWithAlphaComponent(0.8)
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: Measurements.verticalMargin, left: Measurements.horizontalMargin, bottom: Measurements.verticalMargin, right: Measurements.horizontalMargin)
        layout?.minimumInteritemSpacing = 1.0
        layout?.minimumLineSpacing = 1.0
    }

    func didTapCancelButton(sender: UIButton) {
        delegate?.userDidTapCancel()
    }

    func didTapSaveButton(sender: UIButton) {
        let selectedIndexPaths = collectionView?.indexPathsForSelectedItems() ?? []
        let selectedStateNames = selectedIndexPaths.map { self.states[$0.item] }
        delegate?.userDidTapSave(selectedStateNames)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return states.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! USStateCell
    
        cell.label.text = states[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let left = flowLayout?.sectionInset.left ?? 0
        let right = flowLayout?.sectionInset.right ?? 0
        let totalInteritemSpacing = (flowLayout?.minimumInteritemSpacing ?? 0) * CGFloat(columnCount - 1)
        let availableWidth = collectionView.bounds.width - (left + totalInteritemSpacing + right)
        let columnWidth = availableWidth/CGFloat(columnCount)
        return CGSize(width: columnWidth, height: Measurements.buttonHeight)
    }

    let columnCount = 1

}
