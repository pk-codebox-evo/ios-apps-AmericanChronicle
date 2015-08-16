//
//  MapSelectionViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/16/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import MapKit

class MapSelectionViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var savedCallback: ((Void) -> ())?

    @IBAction func buttonTapped(sender: AnyObject) {
        savedCallback?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
