//
//  FilterTableViewCell.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/25/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    @IBOutlet weak var selectButton: UIImageView!
    @IBOutlet weak var rideTypeLabel: UILabel!
    
    weak var delegate: FilterTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
protocol FilterTableViewCellDelegate: class {

}
