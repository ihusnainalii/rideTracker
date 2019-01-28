//
//  StatLabelView.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/27/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

class StatLabelView: UIView {

    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var containerView: UIView!
        
    var width = 1.0
    
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 1.0)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
