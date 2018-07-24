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
    @IBOutlet weak var rideTypeLabel: UILabel!
    @IBOutlet weak var numberOfRidesLabel: UILabel!
    @IBOutlet weak var attractionButton: UIButton!
    @IBOutlet weak var rideCellSquare: UIView!
    @IBOutlet weak var rideCountViewLeadingConstraint: NSLayoutConstraint!
    
    
   // @IBOutlet weak var addRideButton: UIImageView!
    weak var delegate: AttractionsTableViewCellDelegate?
    
   
//    @IBAction func didSelectNegIncrementor(_ sender: Any) {
//        delegate?.attractionCellNegativeIncrement(self)
//    }
    
    @IBAction func didSelectPosIncrement(_ sender: Any) {
        delegate?.attractionCellTapButton(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        minusIncrementButton.layer.borderColor = UIColor(red: 69/255, green: 121/255, blue: 251/255, alpha: 1).cgColor
//        minusIncrementButton.layer.borderWidth = 1
//        minusIncrementButton.layer.cornerRadius = 7
        
    
        
        rideCellSquare.layer.backgroundColor = UIColor.white.cgColor
        rideCellSquare.layer.cornerRadius = 10.0
        rideCellSquare.clipsToBounds = false
        
        rideCellSquare.layer.shadowOpacity = 0.4
        rideCellSquare.layer.shadowOffset = CGSize.zero
        rideCellSquare.layer.shadowRadius = 9
        rideCellSquare.layer.shadowColor = UIColor.black.cgColor
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        rideCellSquare.addGestureRecognizer(tap)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        rideCellSquare.addGestureRecognizer(longPress)
       // rideCounterCellWidth.constant = 50

        // Initialization code
    }
    @objc func tapAction() {
        delegate?.attractionCellTapButton(self)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began{
            delegate?.enterAttractionTally(self)
        }
        if gestureRecognizer.state == UIGestureRecognizerState.ended{
            delegate?.endLongPress(self)

        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

protocol AttractionsTableViewCellDelegate : class {
    func attractionCellTapButton(_ sender: AttractionsTableViewCell)
    func enterAttractionTally(_ sender: AttractionsTableViewCell)
    func endLongPress(_ sender: AttractionsTableViewCell)
   // func attractionCellNegativeIncrement(_ sender: AttractionsTableViewCell)

   // func ignoreAction(_sender: AttractionsViewController)
    
    
}
