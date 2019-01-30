//
//  RCDynamicViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/26/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit

//1/4 width: 60
//1/2 width: 115
//3/4: 144

//Image width: 135

class RCDynamicViewController: UIViewController {
    
    @IBOutlet weak var topRowStack: UIStackView!
    @IBOutlet weak var middleRowStack: UIStackView!
    @IBOutlet weak var bottomRowStack: UIStackView!
    
    let reportCardViewCreator = DynamicReportCardView()
    let logoGreen = UIColor(red: 81/255.0, green: 164/255.0, blue: 76/255.0, alpha: 1.0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createStackViewTop(stackViewBig: topRowStack)
        createStackViewMiddle(stackViewBig: middleRowStack)
        createStackViewBottom(stackViewBig: bottomRowStack)
        
        
    }
    
    func createStackViewTop(stackViewBig: UIStackView){
        
        //image
        let imageView = UIView()
        imageView.backgroundColor = logoGreen
        imageView.widthAnchor.constraint(equalToConstant: 135.0).isActive = true
        
        let view2 = reportCardViewCreator.createviews(size: .fill, type: BoxType.statLabel)
        let view3 = reportCardViewCreator.createviews(size: .threeQuarters, type: BoxType.statLabel)
        let view4 = reportCardViewCreator.createviews(size: .fill, type: BoxType.statAttractionLabel)
        
        let stackView3 = UIStackView()
        stackView3.axis = .vertical
        stackView3.alignment = .fill
        stackView3.distribution = .fillEqually
        stackView3.spacing = 6
        
        stackView3.addArrangedSubview(view3)
        stackView3.addArrangedSubview(view4)
    
        
        stackViewBig.addArrangedSubview(stackView3)
        stackViewBig.addArrangedSubview(view2)
        stackViewBig.addArrangedSubview(imageView)

        
    }
    
    func createStackViewMiddle(stackViewBig: UIStackView){
        
        //image
        let view1 = UIView()
        view1.backgroundColor = logoGreen
        view1.widthAnchor.constraint(equalToConstant: 135.0).isActive = true
        
        let view2 = reportCardViewCreator.createviews(size: .quarter, type: BoxType.statLabel)

        let view3 = reportCardViewCreator.createviews(size: .fill, type: BoxType.topRideList)
        let view4 = reportCardViewCreator.createviews(size: .fill, type: BoxType.statAttractionLabel)

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
    
        let view1 = reportCardViewCreator.createviews(size: .half, type: .topRideList)
        let view2 = reportCardViewCreator.createviews(size: .fill, type: .statLabel)
        let view3 = reportCardViewCreator.createviews(size: .fill, type: .statAttractionLabel)
        
        
        //Blanck view for bottom right corner
        let view4 = UIView()
        view4.backgroundColor = UIColor.clear
        view4.widthAnchor.constraint(equalToConstant: 135.0).isActive = true
        
 
        let stackView3 = UIStackView()
        stackView3.axis = .vertical
        stackView3.alignment = .fill
        stackView3.distribution = .fillEqually
        stackView3.spacing = 6
        
        stackView3.addArrangedSubview(view2)
        stackView3.addArrangedSubview(view3)
        
        
        stackViewBig.addArrangedSubview(view1)
        stackViewBig.addArrangedSubview(stackView3)
        stackViewBig.addArrangedSubview(view4)
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
