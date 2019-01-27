//
//  RCDynamicViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/26/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

class RCDynamicViewController: UIViewController {

    var arrayOfStats = [Stat]()
    var dynamicView = DynamicReportCardView()
    
    override func loadView() {
        view = dynamicView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
