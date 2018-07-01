//
//  SettingsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 5/24/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SettingsViewController: UIViewController {
    var usersParkList: NSMutableArray = NSMutableArray()
    var downloadIncrementor = 0
    // var showExtinct : Int?
    var showExtinct = 0
    var simulateLocation = 0
    var resetPressed : Int?
    
    @IBOutlet weak var showExtinctSwitch: UISwitch!
    @IBOutlet weak var simulateLocationSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetPressed = 0
        if showExtinct == 0{
            showExtinctSwitch.isOn = false
        } else{
            showExtinctSwitch.isOn = true
        }
        
        if simulateLocation == 0{
            simulateLocationSwitch.isOn = false
        } else{
            simulateLocationSwitch.isOn = true
        }
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showExtinct(_ sender: Any) {
        if (showExtinctSwitch.isOn){
            showExtinct = 1
            print("Showing extinct rides")
        }
        else{
            showExtinct = 0
            print("Hiding extinct rides")
        }
        UserDefaults.standard.set(showExtinct, forKey: "showExtinct")
        
    }
    
    @IBAction func simulateLocation(_ sender: Any) {
        if simulateLocationSwitch.isOn{
            simulateLocation = 1
            print("simulating location")
        }
        else{
            simulateLocation = 0
            print("Stopped simulating location")
        }
        UserDefaults.standard.set(simulateLocation, forKey: "simulateLocation")
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toParkList"{
            print("back from settings")
            let listVC = segue.destination as! ViewController
            listVC.showExtinct = showExtinct
            listVC.simulateLocation = simulateLocation
            
            if simulateLocation == 1{
                listVC.currentLocationViewBottomConstraint.constant = -61
                listVC.locationManager.requestWhenInUseAuthorization()
                listVC.locationManager.requestLocation()
                print("GETTING GPS DATA")
            } else{
                listVC.currentLocationViewBottomConstraint.constant = -61

            }
            
        }
    }
}
