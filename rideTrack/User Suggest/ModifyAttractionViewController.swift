//
//  ModifyAttractionViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 7/10/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class ModifyAttractionViewController: UIViewController {

    @IBOutlet weak var suggestedManufacturer: UILabel!
    @IBOutlet weak var suggestedClose: UILabel!
    @IBOutlet weak var suggestedName: UILabel!
    @IBOutlet weak var suggestedType: UILabel!
    @IBOutlet weak var suggestedNotes: UILabel!
    @IBOutlet weak var suggestedOpen: UILabel!
    var originalAttraction: AttractionsModel = AttractionsModel()
    var suggestedAttraction: ApproveSuggestAttracionModel = ApproveSuggestAttracionModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestedName.text=suggestedAttraction.rideName
        let type = convertRideTypeID(rideTypeID: Int(suggestedAttraction.type)!)
        suggestedType.text = type
        suggestedOpen.text = String(suggestedAttraction.YearOpen)
        suggestedClose.text = String(suggestedAttraction.YearClose)
        suggestedNotes.text = suggestedAttraction.notes
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertRideTypeID(rideTypeID: Int) -> String {
        switch rideTypeID {
        case 1:
            return "Roller Coaster"
        case 2:
            return "Water Ride"
        case 3:
            return "Childrens Ride"
        case 4:
            return "Flat Ride"
        case 5:
            return "Transport Ride"
        case 6:
            return "Dark Ride"
        case 7:
            return "Explore"
        case 8:
            return "Spectacular"
        case 9:
            return "Show"
        case 10:
            return "Film"
        case 11:
            return "Parade"
        case 12:
            return "Play Area"
        case 13:
            return "Upcharge"
        default:
            return ""
        }
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
