//
//  suggestParkTableViewCell.swift
//  rideTrack
//
//  Created by Justin Lawrence on 1/9/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//
import UIKit
import Foundation

class suggestParkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    weak var delegate: suggestParkTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
protocol suggestParkTableViewCellDelegate : class {
    
}
