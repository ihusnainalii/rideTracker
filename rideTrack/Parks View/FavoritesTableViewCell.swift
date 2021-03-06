//
//  FavoritesTableViewCell.swift
//  rideTrack
//
//  Created by Mark Lawrence on 6/22/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fractionLabel: UILabel!
    @IBOutlet weak var progressViewBackground: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewBackgroundWidth: NSLayoutConstraint!
    @IBOutlet weak var progressViewBackgroundHeight: NSLayoutConstraint!
    
    let screenSize = UIScreen.main.bounds
    
    var progressWidth: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressViewBackground.layer.cornerRadius = 10
        progressWidth = progressViewBackground.frame.width
        
        progressView.layer.shadowOpacity = 0.4
        progressView.layer.shadowOffset = CGSize.zero
        progressView.layer.shadowRadius = 8
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
