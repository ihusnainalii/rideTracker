//
//  RCDynamicViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/26/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

//3/4 width: 60
//1/2 width: 115
//1/4: 144

//Image width: 135

class RCDynamicViewController: UIViewController {
    
    @IBOutlet weak var topRowStack: UIStackView!
    @IBOutlet weak var middleRowStack: UIStackView!
    @IBOutlet weak var bottomRowStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createStackViewMiddle(stackViewBig: middleRowStack)
        createStackViewBottom(stackViewBig: bottomRowStack)
        
        
    }
    
    func createStackViewMiddle(stackViewBig: UIStackView){
        
        //image
        let view1 = UIView()
        view1.backgroundColor = UIColor.green
        view1.widthAnchor.constraint(equalToConstant: 135.0).isActive = true
        
        let view2 = UIView()
        //view2.backgroundColor = UIColor.yellow
        view2.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        if let customView = Bundle.main.loadNibNamed("StatLabelView", owner: self, options: nil)!.first as? StatLabelView {
            view2.addSubview(customView)
            
            customView.translatesAutoresizingMaskIntoConstraints = false
            view2.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
            view2.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
        }
        
        
        let view3 = UIView()
        view3.backgroundColor = UIColor.purple
        let view4 = UIView()
        view4.backgroundColor = UIColor.blue
        
        if let customView = Bundle.main.loadNibNamed("StatLabelView", owner: self, options: nil)!.first as? StatLabelView {
            view4.addSubview(customView)
            
            customView.translatesAutoresizingMaskIntoConstraints = false
            view4.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
            view4.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
        }
        
        let stackView3 = UIStackView()
        stackView3.axis = .vertical
        stackView3.alignment = .fill
        stackView3.distribution = .fillEqually
        stackView3.spacing = 6
        
        stackView3.addArrangedSubview(view3)
        stackView3.addArrangedSubview(view4)
        
        
        stackViewBig.addArrangedSubview(view1)
        stackViewBig.addArrangedSubview(stackView3)
        stackViewBig.addArrangedSubview(view2)

    }
    
    func createStackViewBottom(stackViewBig: UIStackView){
    
        
        let view1 = UIView()
        view1.widthAnchor.constraint(equalToConstant: 115.0).isActive = true
        view1.backgroundColor = UIColor.blue
        
        let view5 = UIView()
        view5.backgroundColor = UIColor.white
        view5.widthAnchor.constraint(equalToConstant: 135.0).isActive = true
        
        let view3 = UIView()
        //view3.backgroundColor = UIColor.purple
        let view4 = UIView()
        view4.backgroundColor = UIColor.blue
        
        let stackView3 = UIStackView()
        stackView3.axis = .vertical
        stackView3.alignment = .fill
        stackView3.distribution = .fillEqually
        stackView3.spacing = 6
        
        stackView3.addArrangedSubview(view3)
        stackView3.addArrangedSubview(view4)
        
        if let customView = Bundle.main.loadNibNamed("StatLabelView", owner: self, options: nil)!.first as? StatLabelView {
            view3.addSubview(customView)
            
            customView.translatesAutoresizingMaskIntoConstraints = false
            view3.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
            view3.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
        }
        
        
        
        stackViewBig.addArrangedSubview(view1)
        stackViewBig.addArrangedSubview(stackView3)
        stackViewBig.addArrangedSubview(view5)
    }
    
}



class CustomView: UIView {
    var width = 1.0
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 1.0)
    }
}


class CustomStackView: UIStackView {
    var width = 1.0
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 1.0)
    }
}
