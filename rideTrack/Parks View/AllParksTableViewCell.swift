//
//  AllParksTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class AllParksTableViewCell: UITableViewCell {

    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fractionLabel: UILabel!
    @IBOutlet weak var fractionView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var fractionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fractionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var numberOfCheckins: UILabel!
    
    let screenSize = UIScreen.main.bounds
    
    var progressWidth: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fractionView.layer.cornerRadius = 10
        progressWidth = fractionView.frame.width
        
        progressView.layer.shadowOpacity = 0.5
        progressView.layer.shadowOffset = CGSize.zero
        progressView.layer.shadowRadius = 8
        
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
