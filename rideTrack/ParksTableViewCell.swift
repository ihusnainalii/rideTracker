//
//  ParksTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/2/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ParksTableViewCell: UITableViewCell {

    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var totalRidesLabel: UILabel!
    @IBOutlet weak var favoriteIcon: UILabel!
    
    weak var delegate: ParkTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didRemoveFromList(_ sender: Any) {
        delegate?.parkTableViewCellDidRemovePark(self)
    }
    
    @IBAction func didSelectFavorite(_ sender: Any) {
        delegate?.parkTableDidSelectFavorite(self)
    }
    
    
}


protocol ParkTableViewCellDelegate : class {
    func parkTableViewCellDidRemovePark(_ sender: ParksTableViewCell)
    func parkTableDidSelectFavorite(_ sender: ParksTableViewCell)
}
