//
//  TopRideTypeView.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/28/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

class TopRideTypeView: UIView {

    @IBOutlet weak var rideTypeLabel: UILabel!
    @IBOutlet weak var rideNames: UILabel!
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    let logoGreen = UIColor(red: 81/255.0, green: 164/255.0, blue: 76/255.0, alpha: 1.0)

    
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
        rideTypeLabel.textColor = .white
        rideNames.textColor = .white
        statLabel.textColor = .white
    }
    
}
