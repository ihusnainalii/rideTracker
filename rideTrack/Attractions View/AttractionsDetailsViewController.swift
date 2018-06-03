//
//  AttractionsDetailsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 5/28/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit

class AttractionsDetailsViewController: UIViewController {
    var typeString = ""
    var selectedRide = AttractionsModel()
    var favorites = [Int]()
    let favList = UserDefaults.standard
    var isFavorite = false
    //let favorites = favList.array(forKey: "SavedIntArray")  as? [Int] ?? [Int]()
    
    @IBOutlet weak var CurrentlyOpenLabel: UILabel!
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var yearCloseLabel: UITextField!
    @IBOutlet weak var yearOpenLabel: UITextField!
    @IBOutlet weak var yearCloseText: UILabel!
    @IBOutlet weak var attractiontype: UITextField!
    @IBOutlet weak var favButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let savedFavorite = favList.array(forKey: "SavedIntArray")  as? [Int] ?? [Int]()
        
        
        rideNameLabel.text = selectedRide.name
        if selectedRide.yearOpen == 0{
            yearOpenLabel.text = "Unknown"
        }
        else{
            yearOpenLabel.text = String(selectedRide.yearOpen)
        }
        if selectedRide.active == 1 {
            yearCloseLabel.isHidden = true
            yearCloseText.isHidden = true
            
        }
        else {
            yearCloseLabel.text = String (selectedRide.yearClosed)
            CurrentlyOpenLabel.isHidden = true
        }
        
        switch selectedRide.rideType {                       //FIX THIS....THIS ONLY WORKS NOW AS THE DATABASE IS WRONG!!!!
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
        print ("Printing favorite rides")
        for i in 0..<savedFavorite.count{
            print (savedFavorite [i])
            if savedFavorite[i] == selectedRide.rideID {
                print("this is a favorite")
                isFavorite = true
                favButton.setTitleColor(UIColor.yellow, for: .normal)
            }
            favorites.append(savedFavorite[i])
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favButtonToggled(_ sender: Any) {
        if isFavorite == false{
            favButton.setTitleColor(UIColor.yellow, for: .normal)
            isFavorite = true
            print ("Adding ride ID to fav list: ", selectedRide.rideID)
            favorites.append(selectedRide.rideID)
            
        }
        else {
            for i in 0..<favorites.count{
                if favorites[i] == selectedRide.rideID {
                    print("Deleting from list: ", selectedRide.rideID)
                    favorites.remove(at: i)
                    break
                }
            }
            //favorites.remove(at: rideID)
            favButton.setTitleColor(UIColor.black, for: .normal)
            isFavorite = false
        }
        favList.set(favorites, forKey: "SavedIntArray")
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
