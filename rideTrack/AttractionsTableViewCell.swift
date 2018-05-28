//
//  AttractionsTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 5/27/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class AttractionsTableViewCell: UITableViewCell {

    @IBOutlet weak var rideName: UILabel!
    @IBOutlet weak var addRideButton: UIButton!
    
    weak var delegate: AttractionsTableViewCellDelegate?
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.attractionsTableViewCellDidTapAddRide(self)
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol AttractionsTableViewCellDelegate : class {
    func attractionsTableViewCellDidTapAddRide(_ sender: AttractionsTableViewCell)
}
