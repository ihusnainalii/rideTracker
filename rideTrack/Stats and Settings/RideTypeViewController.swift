//
//  RideTypeViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 8/31/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class RideTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var stats: Stats!
    var viewAlreadyLoaded = false
    var rideTypeArray = ["Roller Coasters", "Water Rides", "Shows", "Dark Rides", "Flat Rides", "Films", "Parades", "Spectaculars", "Play Areas", "Transport Rides", "Children's Rides", "Explore", "Upcharged"]
    var checkedRides: [Int]!
    var experiencedRides: [Int]!
    let screenSize = UIScreen.main.bounds

    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 7
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowOffset = CGSize.zero
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.backgroundColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 7
        //tableView.isUserInteractionEnabled = false
        
        viewAlreadyLoaded = true
        updateLabels()
        if screenSize.width == 320.0{
            configureSmallerLayout()
        }
        //rollerCoasterCheckedLabel.text = String(stats.rollerCoasters)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels(){
        checkedRides = [stats.rollerCoasters, stats.waterRides, stats.shows, stats.darkRides, stats.flatRides, stats.spectaculars, stats.parades, stats.films, stats.playAreas, stats.transportRides, stats.childrensRides, stats.exploreRides, stats.upchargeRides]
        experiencedRides = [stats.rollerCoasterExperience, stats.waterExperience, stats.showExperience, stats.darkRidesExperience, stats.flatRideExperience, stats.spectacularExperince, stats.paradesExperience, stats.filmsExperience, stats.playAreaExperience, stats.transportExperience, stats.childrensRideExperience, stats.exploreExperience, stats.upchargeExperience]
        //rollerCoasterCheckedLabel.text = String(stats.rollerCoasters)
    }
    
    func configureSmallerLayout(){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideTypeArray.count
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideTypeCell", for: indexPath) as! RideTypeTableViewCell
        cell.selectionStyle = .none
        cell.attractionTypeLabel.text = rideTypeArray[indexPath.row]
        cell.checkedLabel.text = String(checkedRides[indexPath.row])
        cell.experiencesLabel.text = String(experiencedRides[indexPath.row])
        return cell
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
