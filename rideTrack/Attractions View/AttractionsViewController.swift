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
    @IBOutlet weak var extinctLabel: UILabel!
    @IBOutlet weak var extinctText: UITextField!
    
    var titleName = ""
    var parkID = 0
    var attractionListForTable = [AttractionsModel]()
    var showExtinct = 0
    var showPayed = 0
    var isIgnored = false
    //From the datamigration tool:
    var userAttractionDatabase: [UserAttractionProvider]!
    
    let green = UIColor(red: 120.0/255.0, green: 205.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor as CGColor
    var userAttractions: [NSManagedObject] = []
    var userNumExtinct = 0
    var userRidesRidden = 0
    var RidesComplete = ""
    var extinctComplete = ""
    var rideID = 0
    var rideName = ""
    var totalNumExtinct = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Removes the two negative 1s that get created while saving to CoreData
        //Not good... always going to assume that there are 2 -1s at the beginning of the list
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
                    //Is this line needed???
                    if userDataBaseIndex < maxUserAttractionCount{
                        if (attractionListForTable[i]).rideID == userAttractionDatabase[userDataBaseIndex].rideID{
                            
                            //The user does have data for this ride
                            print ("We have ridden ride # ", userAttractionDatabase[userDataBaseIndex].rideID!)
                            attractionListForTable[i].isCheck = true
                            userRidesRidden += 1
                        
                            attractionListForTable[i].numberOfTimesRidden = userAttractionDatabase[userDataBaseIndex].numberOfTimesRidden
                            attractionListForTable[i].dateLastRidden = userAttractionDatabase[userDataBaseIndex].dateLastRidden
                            attractionListForTable[i].dateFirstRidden = userAttractionDatabase[userDataBaseIndex].dateFirstRidden
                            if attractionListForTable[i].active == 0 {
                                userNumExtinct += 1
                            }
                            userDataBaseIndex += 1
                        }
                        
                        else{
                            //User doesn't have any data stored for this ride
                            attractionListForTable[i].numberOfTimesRidden = 0
                            
                        }

                    }
                    else{
                        //The user does not have any data stored for any of the rest of the rides in this park. Can this be replaced with a break?
                        attractionListForTable[i].numberOfTimesRidden = 0
                        
                    }
                    if attractionListForTable[i].active == 0 && showExtinct == 1 { //&& showExtinct == 1
                         totalNumExtinct += 1
                    }
                    if attractionListForTable[i].numberOfTimesRidden == nil{
                        print("attraction list at rideID \(attractionListForTable[i].rideID!) found nil")
                        attractionListForTable[i].numberOfTimesRidden = 0
                    }
                }
            }
        }
        //Hide EXTINCT ATTRACTIONS
        if(showExtinct == 0 || showPayed == 0){
            var countOfRemove = 0
            for i in 0..<attractionListForTable.count{ //sizeOfList
                if ((attractionListForTable[i - countOfRemove]).active == 0 && showExtinct == 0){
                    //attractionListForTable.removeObject(at: i - countOfRemove)
                    attractionListForTable.remove(at: i-countOfRemove)
                    countOfRemove = countOfRemove+1
                    continue
                }
                if ((attractionListForTable[i-countOfRemove]).rideType == 12 && showPayed == 0){
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
            extinctText.isHidden = false
            extinctLabel.isHidden = false
            extinctComplete = String (userNumExtinct)
            extinctComplete += "/"
            extinctComplete += String (totalNumExtinct)
            extinctText.text = extinctComplete
        }
        else{
            extinctText.isHidden = true
            extinctLabel.isHidden = true
        }
        
        RidesComplete = String(userAttractionDatabase.count-userNumExtinct)
        RidesComplete += "/"
        RidesComplete += String(attractionListForTable.count-totalNumExtinct)
        NumCompleteLabel.text = RidesComplete
        
        self.attractionsTableView.reloadData()

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                cell.addRideButton.isHidden = true
                cell.numberOfRidesLabel.isHidden = false
                cell.plusButtonIncrement.isHidden = false
                cell.minusIncrementButton.isHidden = false
            }
            else{
                cell.rideName?.textColor = UIColor.black
                cell.addRideButton.isEnabled = true
                cell.addRideButton.isHidden = false
                cell.numberOfRidesLabel.isHidden = true
                cell.plusButtonIncrement.isHidden = true
                cell.minusIncrementButton.isHidden = true

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
        cell.numberOfRidesLabel.text = String(item.numberOfTimesRidden)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        attractionsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let ignore = ignoreAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [ignore])
    }
    
    func ignoreAction(at indexPath: IndexPath) ->UIContextualAction{
        let attraction = attractionListForTable[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Ignore") { (action, view, completion) in
            attraction.isIgnored = !attraction.isIgnored
            completion(true)
        }
        if attraction.isIgnored{
        action.backgroundColor = .gray
        }
        else{
            action.backgroundColor = .red
        }
        return action
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
            print ("Seclected Attraction is: ", (self.attractionListForTable[indexPath.row]).rideID)
            
            (self.attractionListForTable[indexPath.row]).isCheck = true
            self.attractionListForTable[indexPath.row].numberOfTimesRidden = 1
            self.attractionListForTable[indexPath.row].dateFirstRidden = Date()
            self.attractionListForTable[indexPath.row].dateLastRidden = Date()
            self.saveUserCheckOffNewRide(parkID: self.parkID, rideID: (self.attractionListForTable[indexPath.row]).rideID);
            self.attractionsTableView.reloadData()
            
            if (self.attractionListForTable[indexPath.row]).active == 0{
                self.userNumExtinct += 1
            }
            
                self.userRidesRidden += 1
            print ("you have been on this many rides: ", self.userRidesRidden)
            //UPDATE RIDES BEEN ON
            self.RidesComplete = String(self.userRidesRidden-self.userNumExtinct)
            self.RidesComplete += "/"
            self.RidesComplete += String(self.attractionListForTable.count - self.totalNumExtinct)
            self.NumCompleteLabel.text = self.RidesComplete
            
            self.extinctComplete = String (self.userNumExtinct)
           self.extinctComplete += "/"
           self.extinctComplete += String (self.totalNumExtinct)
           self.extinctText.text = self.extinctComplete
        }
        alertController.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
    
    func attractionCellNegativeIncrement(_ sender: AttractionsTableViewCell) {
        guard let indexPath = attractionsTableView.indexPath(for: sender) else { return }
        print("Minus")
        
        if attractionListForTable[indexPath.row].numberOfTimesRidden == 1{
            //User is unchecking the ride from their list
            deleteRideCheck(rideID: attractionListForTable[indexPath.row].rideID)
            attractionListForTable[indexPath.row].numberOfTimesRidden = 0
            attractionListForTable[indexPath.row].isCheck = false
            attractionsTableView.reloadData()
            if (attractionListForTable[indexPath.row]).active == 0 {
                userNumExtinct -= 1
            }
            userRidesRidden -= 1
            //UPDATE RIDES BEEN ON
            self.RidesComplete = String(self.userRidesRidden-self.userNumExtinct)
            self.RidesComplete += "/"
            self.RidesComplete += String(self.attractionListForTable.count - self.totalNumExtinct)
            self.NumCompleteLabel.text = self.RidesComplete
            
            self.extinctComplete = String (self.userNumExtinct)
            self.extinctComplete += "/"
            self.extinctComplete += String (self.totalNumExtinct)
            self.extinctText.text = self.extinctComplete
        }
        else{
            let newIncrement = attractionListForTable[indexPath.row].numberOfTimesRidden - 1
            saveIncrementRideCount(rideID:  attractionListForTable[indexPath.row].rideID, incrementTo: newIncrement, postive: false)
            attractionListForTable[indexPath.row].numberOfTimesRidden = newIncrement
            attractionsTableView.reloadData()
        }
    }
    
    func attractionCellPositiveIncrement(_ sender: AttractionsTableViewCell) {
        print("plus")
        guard let indexPath = attractionsTableView.indexPath(for: sender) else { return }
        let newIncrement = attractionListForTable[indexPath.row].numberOfTimesRidden + 1
        saveIncrementRideCount(rideID:  attractionListForTable[indexPath.row].rideID, incrementTo: newIncrement, postive: true)
        attractionListForTable[indexPath.row].numberOfTimesRidden = newIncrement
        attractionListForTable[indexPath.row].dateLastRidden = Date()
        attractionsTableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
  
    
    func saveUserCheckOffNewRide(parkID: Int, rideID: Int) {
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
        newPark.setValue(1, forKey: "numberOfTimesRidden")
        newPark.setValue(Date(), forKey: "firstRideDate")
        newPark.setValue(Date(), forKey: "lastRideDate")
        print("Just saved Attraction: ", rideID)
        do {
            try managedContext.save()
            userAttractions.append(newPark)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteRideCheck(rideID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        fetchRequest.predicate = NSPredicate(format: "rideID = %@", "\(rideID)")
        do
        {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]

            for entity in fetchedResults! {

                managedContext.delete(entity)
                try! managedContext.save()
                print("Deleted ride \(rideID)")
            }
        }
        catch _ {
            print("Could not delete")

        }
        
    }
    
    func saveIncrementRideCount(rideID: Int, incrementTo: Int, postive: Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        fetchRequest.predicate = NSPredicate(format: "rideID = %@", "\(rideID)")
        do
        {
            let fetchedResults =  try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
            
            
            for entity in fetchedResults! {
                entity.setValue(incrementTo, forKey: "numberOfTimesRidden")
                if postive{
                    entity.setValue(Date(), forKey: "lastRideDate")
                }
                try! managedContext.save()
                print("Increment ride \(rideID) to \(incrementTo)")
            }
        }
        catch _ {
            print("Could not increment")
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
            let detailsVC = segue.destination as! AttractionsDetailsViewController
            let selectedIndex = attractionsTableView.indexPathForSelectedRow?.row

            let selectedRide = attractionListForTable[selectedIndex!]
            rideID = selectedRide.rideID
            rideName = selectedRide.name
            print (rideName)
            detailsVC.selectedRide = selectedRide
          //  detailsVC.isFavorite = isFavorite!
            
            
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


