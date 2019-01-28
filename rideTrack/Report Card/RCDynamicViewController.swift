//
//  RCDynamicViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/26/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit



class RCDynamicViewController: UIViewController {
    
    @IBOutlet weak var topRowStack: UIStackView!
    @IBOutlet weak var middleRowStack: UIStackView!
    @IBOutlet weak var bottomRowStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}


class CustomView: UIView {
    var width = 1.0
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 1.0)
    }
}


class CustomStackView: UIStackView {
    var width = 1.0
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 1.0)
    }
}
