//
//  ReportCardTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/20/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

class ReportCardTableViewCell: UITableViewCell {

    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
