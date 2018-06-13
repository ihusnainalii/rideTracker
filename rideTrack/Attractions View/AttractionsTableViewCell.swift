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
    @IBOutlet weak var rideTypeLabel: UILabel!
    @IBOutlet weak var numberOfRidesLabel: UILabel!
    @IBOutlet weak var minusIncrementButton: UIView!
    @IBOutlet weak var plusButtonIncrement: UIButton!
    
    weak var delegate: AttractionsTableViewCellDelegate?
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.attractionsTableViewCellDidTapAddRide(self)
    }
    
    @IBAction func didSelectNegIncrementor(_ sender: Any) {
        delegate?.attractionCellNegativeIncrement(self)
    }
    
    @IBAction func didSelectPosIncrement(_ sender: Any) {
        delegate?.attractionCellPositiveIncrement(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minusIncrementButton.layer.borderColor = UIColor(red: 69/255, green: 121/255, blue: 251/255, alpha: 1).cgColor
        minusIncrementButton.layer.borderWidth = 1
        minusIncrementButton.layer.cornerRadius = 7
        
        plusButtonIncrement.layer.borderColor = UIColor(red: 69/255, green: 121/255, blue: 251/255, alpha: 1).cgColor
        plusButtonIncrement.layer.borderWidth = 1
        plusButtonIncrement.layer.cornerRadius = 7
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

protocol AttractionsTableViewCellDelegate : class {
    func attractionsTableViewCellDidTapAddRide(_ sender: AttractionsTableViewCell)
    func attractionCellPositiveIncrement(_ sender: AttractionsTableViewCell)
    func attractionCellNegativeIncrement(_ sender: AttractionsTableViewCell)

   // func ignoreAction(_sender: AttractionsViewController)
    
    
}
