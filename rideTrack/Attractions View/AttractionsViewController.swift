//
//  AttractionsViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/15/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
// Pushed may 8, 5:40

import UIKit
import CoreData


class AttractionsViewController: UIViewController, UITableViewDataSource, DataModelProtocol, AttractionsTableViewCellDelegate {
   
    
    @IBOutlet weak var attractionsTableView: UITableView!
    @IBOutlet weak var parkLabel: UILabel!
    @IBOutlet weak var NumCompleteLabel: UILabel!
    
    var titleName = ""
    var parkID = 0
    var attractionListForTable = [AttractionsModel]()
    var showExtinct = 0
    var userAttractionDatabase: [UserAttractionProvider]!
    let green = UIColor(red: 120.0/255.0, green: 205.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor as CGColor
    var userAttractions: [NSManagedObject] = []
    var userNumExtinct = 0
    var userRidesRidden = 0
    var RidesComplete = ""
    var rideID = 0
    var rideName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAttractionDatabase.remove(at: 0)
        userAttractionDatabase.remove(at: 0)
        
        //attractionsTableView.allowsSelection = false          //TURN THIS BACK ON
        
        parkLabel.text = titleName
        //self.attractionsTableView.delegate = self as! UITableViewDelegate
        self.attractionsTableView.dataSource = self
        print(parkID)
        let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(parkID)"
        let dataModel = DataModel()
        // print ("There are ", feedItems.count, " attactions in park ", parkID)
        dataModel.delegate = self
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "attractions")
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func itemsDownloaded(items: NSArray) {
        for i in 0..<items.count{
            attractionListForTable.append(items[i] as! AttractionsModel)
            //attractionListForTable.add(items[i])
        }
        
        if (items.count == 0){
            print ("this park is empty")
        }
        else {
            if (userAttractionDatabase != nil){
                var userDataBaseIndex = 0
                let maxUserAttractionCount = userAttractionDatabase.count
                for i in 0..<attractionListForTable.count{
                    if userDataBaseIndex < maxUserAttractionCount{
                        if (attractionListForTable[i]).rideID == userAttractionDatabase[userDataBaseIndex].rideID{
                            print ("We have ridden ride # ", userAttractionDatabase[userDataBaseIndex].rideID!)
                            (attractionListForTable[i]).isCheck = true
                            if attractionListForTable[i].active == 0 {
                                userNumExtinct += 1
                            }
                            userDataBaseIndex += 1
                        }
                        else{
                        }
                    }
                }
            }
        }
        //Hide EXTINCT ATTRACTIONS
        if(showExtinct == 0){
            var countOfRemove = 0
            for i in 0..<attractionListForTable.count{ //sizeOfList
                if ((attractionListForTable[i - countOfRemove]).active == 0){
                    //attractionListForTable.removeObject(at: i - countOfRemove)
                    attractionListForTable.remove(at: i-countOfRemove)
                    countOfRemove = countOfRemove+1
                }
            }
        }
        
        //If user wants to show extinct, sort so that the active rides are on top of the list
            if attractionListForTable.count != 1{
                //Need both steps to sort name alphabetically and by active or not
                attractionListForTable.sort { ($0.active, $1.name) > ($1.active, $0.name) }
        }
        
        //Displays number of rides you have been on out of the total number of rides
        if showExtinct == 1 {
            userRidesRidden = userAttractionDatabase.count
        }
        else{
            userRidesRidden = userAttractionDatabase.count - userNumExtinct
        }
        RidesComplete = String(userRidesRidden)
        RidesComplete += "/"
        RidesComplete += String(attractionListForTable.count)
        NumCompleteLabel.text = RidesComplete
        
        self.attractionsTableView.reloadData()

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var tableSize = 0
//        if (showExtinct == 1){
//            tableSize = attractionListForTable.count
//        }
//        else {
//            tableSize = attractionListForTable.count - numOfExtinct
//        }
        return attractionListForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath) as! AttractionsTableViewCell
        cell.delegate = self
        let item: AttractionsModel = attractionListForTable[indexPath.row]
        if attractionListForTable.count != 1{
            if ((attractionListForTable[indexPath.row]).isCheck){
                cell.rideName?.textColor = UIColor.green
                cell.addRideButton.isEnabled = false
            }
            else{
                cell.rideName?.textColor = UIColor.black
                cell.addRideButton.isEnabled = true

            }
            if (attractionListForTable[indexPath.row]).active == 1 {
                cell.backgroundColor = UIColor.white
            }
            else{
                cell.backgroundColor = UIColor.lightGray
            }
        }
        cell.rideName!.text = item.name
        cell.rideTypeLabel.text = convertRideTypeID(rideTypeID: item.rideType)
        return cell
    }
    
    func convertRideTypeID(rideTypeID: Int) -> String {
        switch rideTypeID {
        case 1:
            return "Roller Coaster"
        case 2:
            return "Water Ride"
        case 3:
            return "Flat Ride"
        case 4:
            return "Transportation Ride"
        case 5:
            return "Dark Ride"
        case 6:
            return "Explore"
        case 7:
            return "Spectacular"
        case 8:
            return "Show"
        case 9:
            return "Film"
        case 10:
            return "Parade"
        case 11:
            return "Play Area"
        case 12:
            return "Upcharge Attraction"
        default:
            return ""
        }
    }
    
    func attractionsTableViewCellDidTapAddRide(_ sender: AttractionsTableViewCell) {
        guard let indexPath = attractionsTableView.indexPath(for: sender) else { return }
        
        let alertController = UIAlertController(title: "Add Attraction", message: "Are you sure you want to add this attraction to your list?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            print ("Seclected Attraction is: ", (self.attractionListForTable[indexPath.row]).rideID);
            
            (self.attractionListForTable[indexPath.row]).isCheck = true;
            self.save(parkID: self.parkID, rideID: (self.attractionListForTable[indexPath.row]).rideID);
            self.attractionsTableView.reloadData()
            //UPDATE RIDES BEEN ON
            self.userRidesRidden += 1
            self.RidesComplete = String(self.userRidesRidden)
            self.RidesComplete += "/"
            self.RidesComplete += String(self.attractionListForTable.count)
            self.NumCompleteLabel.text = self.RidesComplete
        }
        alertController.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save(parkID: Int, rideID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "RideTrack",
                                                in: managedContext)!
        
        let newPark = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        
        newPark.setValue(parkID, forKeyPath: "parkID")
        newPark.setValue(rideID, forKeyPath: "rideID")
        print("Just saved Attraction: ", rideID)
        do {
            try managedContext.save()
            userAttractions.append(newPark)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSuggest"{
            let suggestVC = segue.destination as! SuggestRideViewController
            //selectedPark = feedItems[selectedIndex!] as! ParksModel
            suggestVC.parkName = titleName
            suggestVC.parkID = parkID
        }
        if segue.identifier == "ToDetails"{
            print ("Trying to get details...")
            let detailsVC = segue.destination as! AttractionsDetailsViewController
            let selectedIndex = attractionsTableView.indexPathForSelectedRow?.row
            print ("selected Index is ", selectedIndex)
            //let selectedRide = attractionsTableView[selectedIndex!]
            let selectedRide = attractionListForTable[selectedIndex!]
            rideID = selectedRide.rideID
            rideName = selectedRide.name
            let yearOpen = selectedRide.yearOpen
            let yearClose = selectedRide.yearClosed
            let active = selectedRide.active
            print (rideName)
            detailsVC.rideID = rideID
            detailsVC.rideName = rideName
            detailsVC.yearOpen = yearOpen!
            detailsVC.yearClose = yearClose!
            detailsVC.active = active!
            
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


