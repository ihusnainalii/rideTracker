//
//  ParksDetailViewController.swift
//  rideTrack
//
//  Created by Mark Lawrence on 7/2/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Firebase
import SafariServices

class ParkSettingsViewController: UIViewController {


    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var incrementorSwitch: UISwitch!
    @IBOutlet weak var defunctSwitch: UISwitch!
    @IBOutlet weak var seasonalSwitch: UISwitch!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var parkNameTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var submitAttractionButton: UIButton!
    
    let settingsColor = UIColor(red: 211/255.0, green: 213/255.0, blue: 215/255.0, alpha: 1.0)
 
    var parksData: ParksModel!
    var showDefunct = false
    var showSeasonal = false
    var userName = ""
    var attractionViewController: AttractionsViewController!
    
    var parksListRef: DatabaseReference!
    var favoriteListRef: DatabaseReference!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        
        print("show defunct is currently: \(showDefunct)")
       
        let userID = Auth.auth().currentUser
        let id = userID?.uid
        print(parksData.parkID)
        print (id!)
        
        self.parksListRef = Database.database().reference(withPath: "all-parks-list/\(id!)/\(String(parksData.parkID))")
        self.favoriteListRef = Database.database().reference(withPath: "favorite-parks-list/\(id!)/\(String(parksData.parkID))")
        configueLayout()
        print("show defunct is now: \(showDefunct)")

        incrementorSwitch.isOn = parksData.incrementorEnabled
        defunctSwitch.isOn = showDefunct
        seasonalSwitch.isOn = showSeasonal
        submitAttractionButton.layer.cornerRadius = 7
        
        if UIScreen.main.bounds.height == 812.0 || UIScreen.main.bounds.height == 896.0{
            parkNameTopConstrant.constant = 36
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    func configueLayout(){
        parkNameLabel.text = parksData.name
        
        settingsView.layer.cornerRadius = 7
        settingsView.layer.shadowOpacity = 0.3
        settingsView.layer.shadowOffset = CGSize.zero
        settingsView.layer.shadowRadius = 5
        settingsView.layer.backgroundColor = UIColor.white.cgColor
        
        navBar.layer.shadowOpacity = 0.3
        navBar.layer.shadowOffset = CGSize.zero
        navBar.layer.shadowRadius = 5
    
        
    }
    @IBAction func didToggleIncrementorSwitch(_ sender: Any) {
        parksData.incrementorEnabled = incrementorSwitch.isOn
        parksListRef.updateChildValues([
            "incrementorEnabled": incrementorSwitch.isOn
            ])

    }
    @IBAction func didToggleDefunctSwitch(_ sender: Any) {
        showDefunct = defunctSwitch.isOn
        print("SHOW DEFUNCT: \(showDefunct )")
        parksListRef.updateChildValues([
            "showDefunct": showDefunct
            ])
    }
    
    @IBAction func didToggleSeasonalSwitch(_ sender: Any) {
        showSeasonal = seasonalSwitch.isOn
        parksListRef.updateChildValues(["showSeasonal": showSeasonal])
    }
    
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }

    @IBAction func unwindToDetailsView(sender: UIStoryboardSegue) {
        print("Back to details view")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toSuggestRide"{
            let suggestVC = segue.destination as! SuggestRideViewController
            suggestVC.parkName = parksData.name
            suggestVC.parkID = parksData.parkID
            suggestVC.userName = userName
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("back")
        attractionViewController.updateViewFromSettings(parkDetailVC: self)
    }
    

}
