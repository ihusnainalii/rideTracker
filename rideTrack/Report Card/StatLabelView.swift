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
    
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 9
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.cornerRadius = 20

    }
    

}
