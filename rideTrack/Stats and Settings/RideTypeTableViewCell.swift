//
//  RideTypeTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 9/1/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class RideTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var checkedLabel: UILabel!
    @IBOutlet weak var attractionTypeLabel: UILabel!
    @IBOutlet weak var experiencesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
