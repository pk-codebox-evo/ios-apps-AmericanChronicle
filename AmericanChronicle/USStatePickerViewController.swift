//
//  USStatePickerViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/16/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import CoreLocation

protocol USStatePickerViewInterface {
    var delegate: USStatePickerViewDelegate? { get set }
    var states: [String]? { get set }
    var selectedStates: [String]? { get set }
}

protocol USStatePickerViewDelegate {
    func userDidTapState(stateName: String)
}

class USStatePickerViewController: UIViewController, USStatePickerViewInterface {

    var delegate: USStatePickerViewDelegate?

    var states: [String]?
    var selectedStates: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellowColor()
    }
}
