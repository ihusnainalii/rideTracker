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

class ParkSettingsViewController: UIViewController {

//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var yearOpenLabel: UILabel!
//    @IBOutlet weak var yearClosedLabel: UILabel!
//    @IBOutlet weak var previousNameLabel: UILabel!
    @IBOutlet weak var parkNameLabel: UILabel!
//    @IBOutlet weak var parkTypeLabel: UILabel!
//    @IBOutlet weak var yearClosedStack: UIStackView!
//    @IBOutlet weak var previousNamesStack: UIStackView!
//    @IBOutlet weak var yearOpenStack: UIStackView!
    @IBOutlet weak var incrementorSwitch: UISwitch!
    @IBOutlet weak var defunctSwitch: UISwitch!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    let settingsColor = UIColor(red: 211/255.0, green: 213/255.0, blue: 215/255.0, alpha: 1.0)
 
    var parksData: ParksModel!
    var favoiteParkList = [ParksList]()
    var showDefunct = false
    var loginEmail = ""
    
    var parksListRef: DatabaseReference!
    var favoriteListRef: DatabaseReference!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        let userID = Auth.auth().currentUser
        loginEmail = (userID?.email)!
        let id = userID?.uid
        self.parksListRef = Database.database().reference(withPath: "all-parks-list/\(id!)/\(String(parksData.parkID))")
        self.favoriteListRef = Database.database().reference(withPath: "favorite-parks-list/\(id!)/\(String(parksData.parkID))")
        configueLayout()
        incrementorSwitch.isOn = parksData.incrementorEnabled
        defunctSwitch.isOn = showDefunct
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        doneButton.backgroundColor = settingsColor
        doneButton.layer.cornerRadius = 5
        doneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    @IBAction func didToggleIncrementorSwitch(_ sender: Any) {
        parksData.incrementorEnabled = incrementorSwitch.isOn
        parksListRef.updateChildValues([
            "incrementorEnabled": incrementorSwitch.isOn
            ])
        let favoriteIndex = findIndexFavoritesList(parkID: parksData.parkID)
        if favoriteIndex != -1{
            favoriteListRef.updateChildValues([
                "incrementorEnabled": incrementorSwitch.isOn
                ])
        }
    }
    @IBAction func didToggleDefunctSwitch(_ sender: Any) {
        showDefunct = defunctSwitch.isOn
        print("SHOW DEFUNCT: \(showDefunct )")
        parksListRef.updateChildValues([
            "showDefunct": showDefunct
            ])
        let favoriteIndex = findIndexFavoritesList(parkID: parksData.parkID)
        if favoriteIndex != -1{
            favoriteListRef.updateChildValues([
                "showDefunct": showDefunct
                ])
        }
    }
    
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }

    @IBAction func unwindToDetailsView(sender: UIStoryboardSegue) {
        print("Back to details view")
    }
    

    func findIndexFavoritesList(parkID: Int) -> Int{
        var favoritesIndex = -1
        for i in 0..<favoiteParkList.count{
            if favoiteParkList[i].parkID == parkID{
                favoritesIndex = i
                break
            }
        }
        return favoritesIndex
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
            suggestVC.loginEmail = loginEmail
        }
        
    }
    

}
