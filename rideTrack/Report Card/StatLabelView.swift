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
    @IBOutlet weak var backgroundView: UIView!
    
    let logoGreen = UIColor(red: 81/255.0, green: 164/255.0, blue: 76/255.0, alpha: 1.0)

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 9
        self.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.cornerRadius = 5
    }
    
    func greenMode(){
        backgroundView.layer.backgroundColor = logoGreen.cgColor
        statLabel.textColor = .white
        descriptionLabel.textColor = .white
    }
    

}
