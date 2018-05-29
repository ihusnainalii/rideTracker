//
//  AttractionsDetailsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 5/28/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class AttractionsDetailsViewController: UIViewController {
    var rideID = 0
    var rideName = ""
    var yearClose = 0
    var yearOpen = 0
    var active = 0
    var type = 0
    var typeString = ""
    
    @IBOutlet weak var CurrentlyOpenLabel: UILabel!
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var yearCloseLabel: UITextField!
    @IBOutlet weak var yearOpenLabel: UITextField!
    @IBOutlet weak var yearCloseText: UILabel!
    @IBOutlet weak var attractiontype: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rideNameLabel.text = rideName
        if yearOpen == 0{
            yearOpenLabel.text = "Unknown"
        }
        else{
        yearOpenLabel.text = String(yearOpen)
        }
        if active == 1 {
            yearCloseLabel.isHidden = true
            yearCloseText.isHidden = true
            
        }
        else {
            yearCloseLabel.text = String (yearClose)
            CurrentlyOpenLabel.isHidden = true
        }
        
        switch type {                       //FIX THIS....THIS ONLY WORKS NOW AS THE DATABASE IS WRONG!!!!
        case 1:
            typeString = "Roller Coaster"
        case 2:
            typeString = "Water Ride"
        case 2:
            typeString = "Children's ride"
        case 3:
            typeString = "Flat Ride"
        case 4:
            typeString = "Transportation Ride"
        case 5:
            typeString = "Dark Ride"
        case 6:
            typeString = "Explore"
        case 7:
            typeString = "Spectacular"
        case 8:
            typeString = "Show"
        case 9:
            typeString = "Film"
        case 10:
            typeString = "Parade"
        case 11:
            typeString = "Play Area"
        case 12:
            typeString = "Upcharge Attraction"
        default:
            typeString = "Unknown"
        }
        if typeString == "Unknown"{
            attractiontype.isHidden = true
        }
        attractiontype.text = typeString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
