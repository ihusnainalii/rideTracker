//
//  DynamicReportCardView.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/26/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

class DynamicReportCardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        createviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createviews()
    }
    
    func createviews() {
        
        /*
        backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        self.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView.axis = .vertical
        
        let notice = UILabel()
        notice.numberOfLines = 0
        notice.text = "Your child has attempted to share the following photo from the camera:"
        stackView.addArrangedSubview(notice)
        
        var DynamicView = UIView(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        DynamicView.backgroundColor=UIColor.green
        DynamicView.layer.cornerRadius=25
        DynamicView.layer.borderWidth=2
        self.addSubview(DynamicView)
 */
        
        
    }

}
