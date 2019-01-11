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
    @IBOutlet weak var extendedTappableCheckView: UIView!
    
    
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

        
        rideCellSquare.layer.backgroundColor = UIColor.white.cgColor
        rideCellSquare.layer.cornerRadius = 10.0
        rideCellSquare.clipsToBounds = false
        
        rideCellSquare.layer.shadowOpacity = 0.4
        rideCellSquare.layer.shadowOffset = CGSize.zero
        rideCellSquare.layer.shadowRadius = 9
        rideCellSquare.layer.shadowColor = UIColor.black.cgColor
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        extendedTappableCheckView.addGestureRecognizer(tap)
        
       // rideCellSquare.addGestureRecognizer(tap)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        extendedTappableCheckView.addGestureRecognizer(longPress)
       // rideCellSquare.addGestureRecognizer(longPress)
        // rideCounterCellWidth.constant = 50
        // Initialization code
    }
    @objc func tapAction() {
        //print("TAPPING NOW")
        delegate?.attractionCellTapButton(self)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            delegate?.enterAttractionTally(self)
        }
        if gestureRecognizer.state == UIGestureRecognizer.State.ended{
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
