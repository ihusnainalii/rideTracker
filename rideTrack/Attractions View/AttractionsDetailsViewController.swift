//
//  AttractionsDetailsViewController.swift
//  rideTrack
//
//  Created by Justin Lawrence on 5/28/18.
//  Copyright © 2018 Justin Lawrence. All rights reserved.
//

import UIKit
import CoreData

class AttractionsDetailsViewController: UIViewController {
    
    var typeString = ""
    var selectedRide = AttractionsModel()
    var favorites = [Int]()
    let favList = UserDefaults.standard
    var isFavorite = false
    var modifyDate = Date()
    var comeFromDetails = false
    var userAttractionDatabase: [UserAttractionProvider]!
    var titleName = ""


    //let favorites = favList.array(forKey: "SavedIntArray")  as? [Int] ?? [Int]()
    
    @IBOutlet weak var dateModifyButton: UIButton!
    @IBOutlet weak var CurrentlyOpenLabel: UILabel!
    @IBOutlet weak var rideNameLabel: UILabel!
    @IBOutlet weak var yearCloseLabel: UITextField!
    @IBOutlet weak var yearOpenLabel: UITextField!
    @IBOutlet weak var yearCloseText: UILabel!
    @IBOutlet weak var attractiontype: UITextField!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var dateFirstRiddenLabel: UILabel!
    @IBOutlet weak var dateLastRiddenLabel: UILabel!
    @IBOutlet weak var modifyDateView: UIView!
    @IBOutlet weak var modifyDatePicker: UIDatePicker!
    @IBOutlet weak var scoreCardButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let savedFavorite = favList.array(forKey: "SavedIntArray")  as? [Int] ?? [Int]()
        
        modifyDatePicker.maximumDate = Date()
        scoreCardButton.isHidden = true
        
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
        if selectedRide.isCheck{
            dateFirstRiddenLabel.text = dateFormatter(date: selectedRide.dateFirstRidden)
            
            //Do not show last ride if the user has only ridden the ride once
            if selectedRide.numberOfTimesRidden > 1{
                dateLastRiddenLabel.text = dateFormatter(date: selectedRide.dateLastRidden)
            }
            else{
                dateLastRiddenLabel.isHidden = true
            }
        }
        else{
            dateFirstRiddenLabel.isHidden = true
            dateLastRiddenLabel.isHidden = true
            dateModifyButton.isHidden = true
        }
        
        if selectedRide.hasScoreCard == 1{
            scoreCardButton.isHidden = false
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
    
    @IBAction func didPressModifyDate(_ sender: Any) {
        modifyDateView.isHidden = false
        modifyDatePicker.setDate(selectedRide.dateFirstRidden, animated: false)
    }
    
    @IBAction func didSaveModifyDate(_ sender: Any) {
        modifyDateView.isHidden = true
        dateFirstRiddenLabel.text = dateFormatter(date: modifyDatePicker.date)
        selectedRide.dateFirstRidden = modifyDatePicker.date
        saveModifyFirstRideDate(rideID: selectedRide.rideID, firstRideDate: modifyDatePicker.date)
    }
    
    func saveModifyFirstRideDate(rideID: Int, firstRideDate: Date){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        fetchRequest.predicate = NSPredicate(format: "rideID = %@", "\(rideID)")
        do {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            for entity in fetchedResults! {
                entity.setValue(firstRideDate, forKey: "firstRideDate")
                try! managedContext.save()
                print("Changing first ride date for ride ID \(rideID) to \(firstRideDate)")
            }
        }
        catch _ {
            print("Could not increment")
        }
        
    }
    
    func dateFormatter(date: Date) -> String {
        //let date = Date(timeIntervalSince1970: Double (timeToFormat))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    
     // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScoreCard"{
            let newVC = segue.destination as! ScoreCardViewController
            newVC.selectedRide = selectedRide
        }
        if segue.identifier == "toAttractions"{
            print ("Comeing back")
            let newVC = segue.destination as! AttractionsViewController
            newVC.comeFromDetails = true
            newVC.parkID = selectedRide.parkID
            newVC.titleName = titleName
            newVC.userAttractionDatabase = userAttractionDatabase
        }
    }
    
}
