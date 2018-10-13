//
//  SelectParkTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 10/13/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SelectParkTableViewCell: UITableViewCell {

    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
