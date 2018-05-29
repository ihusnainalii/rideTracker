//
//  SearchTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 5/28/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkLocationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
