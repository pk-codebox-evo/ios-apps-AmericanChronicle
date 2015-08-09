//
//  DetailViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var newspaper: AnyObject? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        if let newspaper: AnyObject = self.newspaper where isViewLoaded() {
            detailDescriptionLabel.text = newspaper.description
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

