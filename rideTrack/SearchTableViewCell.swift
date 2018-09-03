//
//  SearchTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 5/28/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var greenDot: UIImageView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkLocationLabel: UILabel!
    
    let screenSize = UIScreen.main.bounds
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if screenSize.width == 320.0{
            parkNameLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
            parkLocationLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
