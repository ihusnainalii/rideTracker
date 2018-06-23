//
//  AllParksTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class AllParksTableViewCell: UITableViewCell {

    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fractionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
