//
//  SuggestTableViewCell.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/3/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SuggestTableViewCell: UITableViewCell {
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var parkNameLabel: UILabel!
    
    weak var delegate: SuggestTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
protocol SuggestTableViewCellDelegate : class {
    
}
