//
//  DynamicReportCardView.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/26/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

//1/4 width: 60
//1/2 width: 115
//3/4: 144

import UIKit

class DynamicReportCardView: NSObject {
    
    
    func createviews(size: PreferedSize, type: BoxType) -> UIView {
        let createdView = UIView()
        
        switch size {
        case .quarter:
            createdView.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        case .half:
            createdView.widthAnchor.constraint(equalToConstant: 115.0).isActive = true
        case .threeQuarters:
            createdView.widthAnchor.constraint(equalToConstant: 144.0).isActive = true
        case .fill:
            print("No width, fill dynamically")
        }
        
        switch type {
        case .statLabel:
            createStatLabelView(createdView: createdView)
        case .statAttractionLabel:
            createStatLavelAttractionView(createdView: createdView)
        case .topRideList:
            createTopRideTypeView(createdView: createdView)
        }
        return createdView
    }
    
    private func createStatLabelView(createdView: UIView){
        if let customView = Bundle.main.loadNibNamed("StatLabelView", owner: self, options: nil)!.first as? StatLabelView {
            createdView.addSubview(customView)
            customView.greenMode()
            customView.translatesAutoresizingMaskIntoConstraints = false
            createdView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
            createdView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
        }
    }
    
    private func createStatLavelAttractionView(createdView: UIView){
        if let customView = Bundle.main.loadNibNamed("StatLabelAttractionView", owner: self, options: nil)!.first as? StatLabelAttractionView {
            createdView.addSubview(customView)
            
            
            
            customView.translatesAutoresizingMaskIntoConstraints = false
            createdView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
            createdView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
        }
    }
    
    private func createTopRideTypeView(createdView: UIView){
        if let customView = Bundle.main.loadNibNamed("TopRideTypeView", owner: self, options: nil)!.first as? TopRideTypeView {
            createdView.addSubview(customView)
            
            customView.translatesAutoresizingMaskIntoConstraints = false
            createdView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
            createdView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
        }
    }
    
}
