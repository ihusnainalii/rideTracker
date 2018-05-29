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
    
    @IBOutlet weak var CurrentlyOpenLabel: UILabel!
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var yearCloseLabel: UITextField!
    @IBOutlet weak var yearOpenLabel: UITextField!
    @IBOutlet weak var yearCloseText: UILabel!
    
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
