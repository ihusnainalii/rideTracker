//
//  SelectAttractionTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 10/13/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SelectAttractionTableViewCell: UITableViewCell {

    @IBOutlet weak var attractionNameLabel: UILabel!
    @IBOutlet weak var rideTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
