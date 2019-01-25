//
//  MyTripsTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/24/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

class MyTripsTableViewCell: UITableViewCell {

    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
