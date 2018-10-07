//
//  SuggestParkViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 10/7/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class SuggestParkViewController: UIViewController {
    @IBOutlet weak var parkNameField: UITextField!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var openField: UITextField!
    @IBOutlet weak var defuntSwitch: UISwitch!
    @IBOutlet weak var closedField: UITextField!
    @IBOutlet weak var previousNamesField: UITextField!
    @IBOutlet weak var seasonalSwitch: UISwitch!
    @IBOutlet weak var websiteField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
