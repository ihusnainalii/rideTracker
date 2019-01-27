//
//  RCDynamicViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 1/26/19.
//  Copyright © 2019 Justin Lawrence. All rights reserved.
//

import UIKit
//
//class RCDynamicViewController: UIViewController {
//
//    var arrayOfStats = [Stat]()
//    var dynamicView = DynamicReportCardView()
//
//    override func loadView() {
//        view = dynamicView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//}


class RCDynamicViewController: UIViewController {
    //MARK: Properties
    
    let colorDictionary = [
        "Red":UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
        "Green":UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0),
        "Blue":UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0),
        "purple":UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0),
        ]
    
    //MARK: Instance methods
    func colorButton(withColor color:UIColor, title:String) -> UIButton{
        let newButton = UIButton(type: .system)
        newButton.backgroundColor = color
        newButton.setTitle(title, for: .normal)
        newButton.setTitleColor(UIColor.white, for: .normal)
        return newButton
    }
    
    
    func displayKeyboard(){
        //generate an array
        
        
        var buttonArray = [UIButton]()
        for (myKey,myValue) in colorDictionary{
            buttonArray += [colorButton(withColor: myValue, title: myKey)]
        }
    
        
        //Iteration two - nested stack views
        //set up the stack view
        let subStackView = UIStackView(arrangedSubviews: buttonArray)
        subStackView.axis = .horizontal
        subStackView.distribution = .fillEqually
        subStackView.alignment = .fill
        subStackView.spacing = 10
        //set up a label
        let label = UILabel()
        label.text = "Color Chooser"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.textAlignment = .center
        
        let blackButton = colorButton(withColor: UIColor.black, title: "Black")
        
        
        
        let statView1 = createStatView()
        let statView2 = createStatView()
        let statView3 = createStatView()
        
        let twoStatsStack = CustomStackView(arrangedSubviews: [statView1,statView2])
        twoStatsStack.axis = .vertical
        twoStatsStack.distribution = .fillEqually
        twoStatsStack.alignment = .fill
        twoStatsStack.spacing = 10
        twoStatsStack.translatesAutoresizingMaskIntoConstraints = false
        
        
//        twoStatsStack.intrinsicContentSize = CGSize(width: 1, height: 3)
//        statView3.intrinsicContentSize = CGSize(width: 1, height: 3)

        statView3.width = 4
        twoStatsStack.width = 20
        
        
        
        let threeStatsStack = UIStackView(arrangedSubviews: [twoStatsStack,statView3])
        threeStatsStack.axis = .horizontal
        threeStatsStack.distribution = .fillProportionally
        threeStatsStack.alignment = .fill
        threeStatsStack.spacing = 10
        threeStatsStack.translatesAutoresizingMaskIntoConstraints = false
        //middleView.addSubview(middleViewStack)
        
        
        let stackView = UIStackView(arrangedSubviews: [label,subStackView,threeStatsStack,blackButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        //autolayout the stack view - pin 30 up 20 left 20 right 30 down
        let viewsDictionary = ["stackView":stackView]
        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[stackView]-20-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[stackView]-30-|", options: NSLayoutConstraint.FormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        view.addConstraints(stackView_H)
        view.addConstraints(stackView_V)
    }
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayKeyboard()
        
    }
    
    func createStatView()->CustomView{
        let stat = UILabel()
        stat.textAlignment = .left
        stat.text = "32"
        stat.font = UIFont.systemFont(ofSize: 38, weight: .semibold)
        stat.numberOfLines = 1
        stat.textColor = UIColor.green
        
        let statLabel = UILabel()
        statLabel.textAlignment = .left
        statLabel.text = "Number of Attractions Experienced"
        statLabel.numberOfLines = 3
        statLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        
        let middleView = CustomView()
        middleView.backgroundColor = UIColor.orange
        middleView.layer.cornerRadius = 7
        let middleViewStack = UIStackView(arrangedSubviews: [stat,statLabel])
        middleViewStack.axis = .vertical
        middleViewStack.distribution = .equalSpacing
        middleViewStack.alignment = .fill
        middleViewStack.spacing = 4
        middleViewStack.translatesAutoresizingMaskIntoConstraints = false
        middleView.addSubview(middleViewStack)
       
        return middleView
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
